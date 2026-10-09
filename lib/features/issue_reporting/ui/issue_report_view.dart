import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/resources/app_theme.dart';
import '../../../core/shared/widgets/app_ui.dart';
import '../../localization/generated/app_localizations.dart';
import '../cubit/issue_report_cubit.dart';
import '../data/issue_draft_store.dart';
import '../data/issue_report.dart';
import '../data/issue_report_repository.dart';
import '../data/report_media_service.dart';
import 'attachment_preview.dart';
import 'report_problem_text.dart';

class IssueReportView extends StatelessWidget {
  const IssueReportView({required this.arguments, super.key});
  final IssueReportArguments arguments;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) {
      final store = serviceLocator<IssueDraftStore>();
      return IssueReportCubit(
        repository: serviceLocator<IssueReportRepository>(),
        store: store,
        media: ReportMediaService(store),
        screen: arguments.screen,
      )..initialize(screenshot: arguments.screenshot);
    },
    child: const _ReportForm(),
  );
}

class _ReportForm extends StatefulWidget {
  const _ReportForm();

  @override
  State<_ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<_ReportForm> {
  final _description = TextEditingController();
  final _expected = TextEditingController();

  @override
  void dispose() {
    _description.dispose();
    _expected.dispose();
    super.dispose();
  }

  void _syncControllers(IssueReportState state) {
    if (_description.text != state.description) {
      _description.value = TextEditingValue(
        text: state.description,
        selection: TextSelection.collapsed(offset: state.description.length),
      );
    }
    if (_expected.text != state.expected) {
      _expected.value = TextEditingValue(
        text: state.expected,
        selection: TextSelection.collapsed(offset: state.expected.length),
      );
    }
  }

  Future<void> _discard(IssueReportCubit cubit) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.discardDraft),
        content: Text(l.discardDraftPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.discard),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    try {
      await cubit.discard();
      if (mounted) {
        Navigator.pop(context);
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.reportStorageUnavailable)));
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<IssueReportCubit, IssueReportState>(
    listener: (context, state) => _syncControllers(state),
    builder: (context, state) {
      final l = AppLocalizations.of(context);
      final cubit = context.read<IssueReportCubit>();
      final editable = !state.sending && !state.preparing;
      if (state.status == ReportStatus.sent) {
        return Scaffold(
          appBar: AppBar(title: Text(l.reportIssue)),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppIconBadge(
                    icon: Icons.check_rounded,
                    size: 88,
                    color: Color(0xff087E78),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    cubit.simulated
                        ? l.reportSimulatedTitle
                        : l.reportSentTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cubit.simulated
                        ? l.reportSimulatedSubtitle
                        : l.reportSentSubtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SelectableText('${l.reportReference}: ${state.reference}'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.done),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return PopScope(
        canPop: !state.sending && !state.preparing,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.reportIssue),
            actions: [
              IconButton(
                tooltip: l.discardDraft,
                onPressed: editable ? () => _discard(cubit) : null,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          body: AppPageBody(
            children: [
              AppNotice(
                text: l.reportDraftNotice,
                icon: Icons.lock_outline_rounded,
              ),
              const SizedBox(height: 16),
              if (cubit.simulated) ...[
                AppNotice(text: l.reportSimulationNotice),
                const SizedBox(height: 16),
              ],
              if (!cubit.configured) ...[
                AppNotice(text: l.uploadNotConfigured),
                const SizedBox(height: 16),
              ],
              Text(
                '${l.reportScreen}: ${state.screen}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              AppSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.reportDetailsTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      key: const Key('report_description'),
                      controller: _description,
                      enabled: editable,
                      maxLength: 4000,
                      minLines: 4,
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: l.reportDescription,
                        hintText: l.reportDescriptionHint,
                        alignLabelWithHint: true,
                      ),
                      onChanged: cubit.descriptionChanged,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const Key('report_expected'),
                      controller: _expected,
                      enabled: editable,
                      maxLength: 2000,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: l.reportExpected,
                        hintText: l.reportExpectedHint,
                        alignLabelWithHint: true,
                      ),
                      onChanged: cubit.expectedChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.reportAttachments,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.reportMediaLimits,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        OutlinedButton.icon(
                          onPressed:
                              editable &&
                                  state.attachments
                                          .where(
                                            (a) =>
                                                a.kind == AttachmentKind.image,
                                          )
                                          .length <
                                      ReportMediaService.maxImages
                              ? cubit.addImages
                              : null,
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          label: Text(l.addScreenshots),
                        ),
                        OutlinedButton.icon(
                          onPressed:
                              editable &&
                                  !state.attachments.any(
                                    (a) => a.kind == AttachmentKind.video,
                                  )
                              ? cubit.addVideo
                              : null,
                          icon: const Icon(Icons.video_library_outlined),
                          label: Text(l.addVideo),
                        ),
                      ],
                    ),
                    for (final attachment in state.attachments)
                      Card(
                        margin: const EdgeInsets.only(top: 12),
                        child: ListTile(
                          onTap: editable
                              ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => AttachmentPreview(
                                      attachment: attachment,
                                    ),
                                  ),
                                )
                              : null,
                          leading: attachment.kind == AttachmentKind.image
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(attachment.path),
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, error, stack) =>
                                        const Icon(Icons.broken_image_outlined),
                                  ),
                                )
                              : const Icon(
                                  Icons.play_circle_outline_rounded,
                                  size: 40,
                                ),
                          title: Text(
                            attachment.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${(attachment.bytes / (1024 * 1024)).toStringAsFixed(1)} MB · ${l.previewAttachment}',
                          ),
                          trailing: IconButton(
                            tooltip: l.removeAttachment,
                            onPressed: editable
                                ? () => cubit.removeAttachment(attachment)
                                : null,
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.privacyTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.reportDiagnostics),
                      subtitle: Text(l.reportDiagnosticsSubtitle),
                      value: state.diagnostics != null,
                      onChanged: editable
                          ? (value) => cubit.diagnosticsChanged(enabled: value)
                          : null,
                    ),
                    if (state.diagnostics != null)
                      Card(
                        child: ExpansionTile(
                          title: Text(
                            l.reportDiagnostics,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          childrenPadding: const EdgeInsets.all(16),
                          children: [
                            SelectableText(
                              const JsonEncoder.withIndent('  ')
                                  .convert(state.diagnostics),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: AppTheme.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    CheckboxListTile(
                      key: const Key('report_consent'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        l.reportConsent,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      value: state.consent,
                      onChanged: editable
                          ? (value) =>
                                cubit.consentChanged(consent: value ?? false)
                          : null,
                    ),
                  ],
                ),
              ),
              if (state.problem != null) ...[
                const SizedBox(height: 12),
                AppNotice(text: reportProblemText(l, state.problem!)),
              ],
              if (state.preparing) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              const SizedBox(height: 20),
              if (state.sending) ...[
                Text('${l.sendingReport} ${(state.progress * 100).round()}%'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: state.progress > 0 ? state.progress : null,
                ),
                TextButton(
                  onPressed: cubit.cancelUpload,
                  child: Text(l.cancelUpload),
                ),
              ] else
                FilledButton.icon(
                  onPressed:
                      editable &&
                          cubit.configured &&
                          state.consent &&
                          state.description.trim().isNotEmpty
                      ? cubit.submit
                      : null,
                  icon: const Icon(Icons.send_rounded),
                  label: Text(
                    state.status == ReportStatus.failed
                        ? l.retryReport
                        : l.sendReport,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
