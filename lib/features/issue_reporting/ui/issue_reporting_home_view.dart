import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/shared/widgets/app_ui.dart';
import '../../localization/generated/app_localizations.dart';
import '../data/issue_report_repository.dart';
import '../data/issue_reporting_controller.dart';

class IssueReportingHomeView extends StatelessWidget {
  const IssueReportingHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = serviceLocator<IssueReportingController>();
    final repository = serviceLocator<IssueReportRepository>();
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.reportFeatureTitle)),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => AppPageBody(
          children: [
            AppHeroCard(
              title: l.reportHomeTitle,
              subtitle: l.reportHomeSubtitle,
              icon: Icons.chat_bubble_outline_rounded,
            ),
            const SizedBox(height: 24),
            AppSectionCard(
              padding: const EdgeInsets.all(8),
              child: SwitchListTile.adaptive(
                secondary: const AppIconBadge(
                  icon: Icons.vibration_rounded,
                  size: 44,
                ),
                title: Text(
                  l.shakeToReport,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    l.shakeSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                value: controller.shakeEnabled,
                onChanged: !controller.ready
                    ? null
                    : (value) async {
                        final saved = await controller.setShakeEnabled(
                          enabled: value,
                        );
                        if (!saved && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l.shakeSettingFailed)),
                          );
                        }
                      },
              ),
            ),
            const SizedBox(height: 16),
            AppSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppIconBadge(
                        icon: Icons.attachment_rounded,
                        size: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.reportAttachments,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l.reportMediaLimits),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppNotice(
              text: l.reportDraftNotice,
              icon: Icons.lock_outline_rounded,
            ),
            if (repository.simulated) ...[
              const SizedBox(height: 16),
              AppNotice(text: l.reportSimulationNotice),
            ],
            if (!repository.configured) ...[
              const SizedBox(height: 16),
              AppNotice(text: l.uploadNotConfigured),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: controller.opening ? null : controller.openReporter,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(l.startReport),
            ),
          ],
        ),
      ),
    );
  }
}
