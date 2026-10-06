import 'package:core_utils/core_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:structure/core/helpers/localization_helper.dart';
import 'package:twist_music_player/twist_music_player.dart';

/// Add the Twist tracks endpoint here when it is available.
const String twistLaneUrl = 'https://api.twistmena.com/music/guest/tracks';

/// Used only when the lane response does not include its own download URL.
const String twistDownloadFallbackUrl = 'https://example.com';

/// App-side override for the Twist download prompt.
const int twistPromptIntervalSeconds = 30;
const int twistPromptMaxCount = 1;

Future<void> initializeTwistMusicPlayer() {
  return TwistMusicPlayer.init(
    TwistMusicConfig(
      laneSource: _LocalizedTwistLaneSource(
        HttpTwistLaneSource(
          Uri.parse(twistLaneUrl),
          headers: () => {
            'Accept-Language':
                LocalizationHelper.localeNotifier.value.languageCode,
          },
        ),
      ),
      onAnalyticsEvent: (name, parameters) {
        AppLogs.observerLog('[twist_analytics] $name $parameters');
      },
      downloadFallbackUrl: Uri.parse(twistDownloadFallbackUrl),
      branding: const TwistBranding(
        headerLogo: AssetImage('assets/images/pngs/logo.png'),
        promoLogo: AssetImage('assets/images/pngs/logo.png'),
      ),
      androidNotificationChannelId: 'com.shawky.structure.music',
      onError: (error, stackTrace) {
        debugPrint('[twist_music_player] $error');
      },
    ),
  );
}

/// Uses the package's Arabic lane labels when the backend still responds with
/// English copy. Track titles and artist names always remain server-provided.
class _LocalizedTwistLaneSource implements TwistLaneSource {
  const _LocalizedTwistLaneSource(this._source);

  final TwistLaneSource _source;

  @override
  Future<TwistLane> load() async {
    final lane = await _source.load();
    final isArabic =
        LocalizationHelper.localeNotifier.value.languageCode == 'ar';
    final backendCopy = '${lane.title ?? ''} ${lane.subTitle ?? ''}';
    final backendHasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(backendCopy);

    final usePackageArabicCopy = isArabic && !backendHasArabic;

    return TwistLane(
      title: usePackageArabicCopy ? null : lane.title,
      subTitle: usePackageArabicCopy ? null : lane.subTitle,
      downloadUrl: lane.downloadUrl,
      tracks: lane.tracks,
      downloadPrompt: const TwistDownloadPromptPolicy(
        isEnabled: true,
        maxCount: twistPromptMaxCount,
        intervalSeconds: twistPromptIntervalSeconds,
      ),
    );
  }
}
