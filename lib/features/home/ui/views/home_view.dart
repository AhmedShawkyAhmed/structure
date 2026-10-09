import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/helpers/localization_helper.dart';
import 'package:structure/features/home/data/app_features.dart';
import 'package:structure/features/issue_reporting/data/issue_reporting_controller.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';
import 'package:twist_music_player/twist_music_player.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        title: const Text('Structure'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: l.reportIssue,
            onPressed: serviceLocator<IssueReportingController>().openReporter,
            icon: const Icon(Icons.bug_report_outlined),
          ),
          TextButton.icon(
            onPressed: () => LocalizationHelper.changeLocal(
              isArabic ? Languages.en : Languages.ar,
            ),
            icon: const Icon(Icons.language_rounded),
            label: Text(isArabic ? l.english : l.arabic),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          TwistPlayerHost.bottomPaddingOf(context) + 32,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xff151A2D), Color(0xff343B63)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.widgets_rounded,
                  color: Color(0xffBAA9FF),
                  size: 36,
                ),
                const SizedBox(height: 18),
                Text(
                  l.featureHubTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l.featureHubSubtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          for (final feature in appFeatures)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                  side: const BorderSide(color: Color(0xffE8EAF2)),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => Navigator.pushNamed(context, feature.route.path),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: feature.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Icon(
                            feature.icon,
                            color: feature.color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature.title(l),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                feature.subtitle(l),
                                style: const TextStyle(
                                  color: Color(0xff74788D),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xff9DA2B5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
