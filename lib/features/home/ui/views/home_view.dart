import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/helpers/localization_helper.dart';
import 'package:structure/core/resources/app_theme.dart';
import 'package:structure/core/shared/widgets/app_ui.dart';
import 'package:structure/features/home/data/app_features.dart';
import 'package:structure/features/issue_reporting/data/issue_reporting_controller.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final reporter = serviceLocator<IssueReportingController>();
    final homeFeatures = appFeatures
        .where((feature) => feature.visibleOnHome)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              if (constraints.maxWidth >= 160) ...[
                const AppIconBadge(icon: Icons.layers_rounded, size: 36),
                const SizedBox(width: 10),
              ],
              const Expanded(
                child: Text('Structure', overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: l.reportIssue,
            onPressed: reporter.openReporter,
            icon: const Icon(Icons.bug_report_outlined, size: 22),
          ),
          TextButton(
            onPressed: () => LocalizationHelper.changeLocal(
              isArabic ? Languages.en : Languages.ar,
            ),
            child: Text(isArabic ? l.english : l.arabic),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: AppPageBody(
        maxWidth: 1000,
        children: [
          AppHeroCard(
            eyebrow: l.workspaceEyebrow,
            title: l.featureHubTitle,
            subtitle: l.featureHubSubtitle,
            icon: Icons.auto_awesome_rounded,
            footer: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.ink,
              ),
              onPressed: reporter.openReporter,
              icon: const Icon(Icons.edit_note_rounded, size: 20),
              label: Text(l.startReport),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            l.exploreFeatures,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 760
                  ? 3
                  : constraints.maxWidth >= 320 &&
                        MediaQuery.textScalerOf(context).scale(1) < 1.4
                  ? 2
                  : 1;
              return Column(
                children: [
                  for (
                    var index = 0;
                    index < homeFeatures.length;
                    index += columns
                  )
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (
                              var column = 0;
                              column < columns;
                              column++
                            ) ...[
                              if (column > 0) const SizedBox(width: 14),
                              Expanded(
                                child: index + column < homeFeatures.length
                                    ? _FeatureCard(
                                        feature: homeFeatures[index + column],
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          ListenableBuilder(
            listenable: reporter,
            builder: (context, _) => AppSectionCard(
              child: Row(
                children: [
                  const AppIconBadge(icon: Icons.vibration_rounded, size: 44),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.quickReportTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reporter.shakeEnabled
                              ? l.quickReportSubtitle
                              : l.reportFeatureSubtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l.startReport,
                    onPressed: reporter.opening ? null : reporter.openReporter,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: AppTheme.violet,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});
  final AppFeature feature;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, feature.route.path),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppIconBadge(
                    icon: feature.icon,
                    color: feature.color,
                    size: 44,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    size: 17,
                    color: AppTheme.muted,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                feature.title(l),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                feature.subtitle(l),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
