# Issue reporting and the feature launcher

`lib/main.dart` only starts the application. `app_bootstrap.dart` initializes shared
services and calls each feature's setup. The home screen reads `appFeatures` and
opens each feature's own route and view. Twist's setup and UI live under
`features/twist`; device diagnostics keeps its existing service and screen;
reporting lives under `features/issue_reporting`.

To expose another feature, add an `AppRoutes` value, map it to its view in
`AppRouter`, and add an entry in `appFeatures`. Add feature-specific initialization
to the application bootstrap when needed.

## User flow

Shake on an active Android/iOS device, use the home toolbar's report button, or
open Issue reporting from the launcher. Shaking requires three separate peaks
within 900 milliseconds, with a four-second cooldown. The sensor subscription
stops in the background and while a reporter is open. Missing sensors do not
disable the manual action. The shake preference is saved on the device.

The initial prompt asks whether to capture the current app screen. Capture is
off by default and happens only after Continue. It captures Flutter-rendered
content; embedded native/platform views and protected content may not appear.
The report remembers the original named route before its form opens.

Users enter a description and optional expected behavior, attach up to three
JPG/PNG images and one MP4/MOV video, preview or remove attachments, optionally
include technical details, and explicitly agree to sharing before sending.
Each file must be non-empty and at most 50 MiB; videos may not exceed 60 seconds.
The first version supports uploading existing videos, including screen recordings
made with the device's own recorder. It does not start an in-app recording.

Diagnostics include only app version/build, platform, device model, and OS
version. They are collected on opt-in, displayed before submission, and omitted
when disabled. Device IDs, raw logs, network payloads, device names, and the
complete device diagnostics snapshot are not attached. Changing report content
revokes the sharing checkbox and rotates the client report ID.

Description and copies of selected attachments are saved as one local draft in
the app support directory. Gallery originals are never deleted. Closing the form
or restarting the app preserves the draft, which is restored when reporting is
opened again. Consent and diagnostic values are not persisted. Android picker
results recovered after process death are imported on reopening the form.
Discarding or successfully sending clears the draft and its local copies.

## Connect the backend

No reporting backend is present in this repository. Debug builds without an
endpoint default to simulation: consent is still required, Dio consumes the real
multipart media stream locally, upload progress and cancellation work, and the
client returns HTTP 201 after a short delay:

```json
{"reference": "SIMULATED-<clientReportId>"}
```

The form and receipt clearly label simulated submissions; no network connection
is opened. A completed simulation clears the draft, just like a successful live
submission. The same report ID yields the same simulated reference on retries.

After consent, debug builds print the formatted `report` JSON and response to
the Flutter debug console. The printed body includes attachment metadata and
opted-in diagnostics, but excludes file paths, file contents and auth headers.
Profile/release builds never enable simulation or these logs.

To explicitly enable simulation, including when an endpoint is configured:

```sh
flutter run --dart-define=ISSUE_REPORT_SIMULATE=true
```

To disable it and verify the missing-backend state:

```sh
flutter run --dart-define=ISSUE_REPORT_SIMULATE=false
```

Configure the endpoint at build time for real submissions (this disables
simulation by default). Profile/release builds without it disable sending:

```sh
flutter run --dart-define=ISSUE_REPORT_ENDPOINT=https://your-api.example/issue-reports
```

The endpoint must be an absolute HTTPS URL. Reporting uses its own Dio client
without automatic device ID headers or production body logging. If the app
has populated `Globals.token`, the client includes it as a Bearer token. Replace
the `IssueReportRepository` registration to integrate another support provider
or a different authentication/upload flow.

`POST` uses multipart form data:

- `report`: a JSON string with `clientReportId`, `description`,
  `expectedBehavior`, `screen`, `consent`, optional `diagnostics`, and
  `attachments` metadata (`name`, `kind`, `mimeType`, `bytes`).
- Repeated `attachments` file parts, in metadata order, with their MIME types.
- `Idempotency-Key` header: the draft's `clientReportId`.

Consent includes `shareReport: true`, `includeDiagnostics`, policy `version: 1`,
and the UTC `confirmedAt` timestamp. A successful response must be HTTP 2xx with
an object containing a non-empty string reference:

```json
{"reference": "REPORT-123"}
```

The backend must implement idempotency: retries of a previously accepted client
report ID return its original reference and must not create duplicate tickets.
The client preserves the ID for unchanged retries. If draft restoration removes
missing media or previously included diagnostic data, it rotates the ID because
the report content has changed. Consent confirmation timestamps can change on a
retry; the server must use the report ID rather than timestamp equality.

Upload progress, cancellation, and failures keep the draft. Cancellation stops
the client request, but cannot retract a report already accepted by the server.
Only a valid response reference produces the receipt screen. Simulated receipts
explicitly state that no report was uploaded.

The receiving service must validate attachment content, counts, sizes, video
duration, and consent independently; store attachments privately; authorize
support access; rate-limit submissions; and establish its retention/deletion
policy. Those backend responsibilities cannot be enforced by this Flutter app.

## Validation

Run `flutter analyze` and `flutter test`. Reporting tests cover consent guards,
diagnostic opt-in, multipart fields, media signatures and limits, local draft
recovery, cancellation, duplicate send prevention, retry IDs, and shake debounce.
Sensor thresholds should also be checked on real Android/iOS hardware. Simulators
are suitable for the manual flow and rendering, but do not reproduce physical
shake behavior.
