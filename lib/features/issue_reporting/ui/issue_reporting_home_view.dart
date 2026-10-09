import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../../localization/generated/app_localizations.dart';
import '../data/issue_report_repository.dart';
import '../data/issue_reporting_controller.dart';

class IssueReportingHomeView extends StatelessWidget {
  const IssueReportingHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = serviceLocator<IssueReportingController>();
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(title: Text(l.reportFeatureTitle)),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(
              Icons.bug_report_rounded,
              size: 72,
              color: Color(0xff7C5CFC),
            ),
            const SizedBox(height: 24),
            Text(
              l.reportHomeTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(l.reportHomeSubtitle),
            if (serviceLocator<IssueReportRepository>().simulated) ...[
              const SizedBox(height: 16),
              Text(l.reportSimulationNotice),
            ],
            const SizedBox(height: 24),
            Card(
              child: SwitchListTile.adaptive(
                title: Text(l.shakeToReport),
                subtitle: Text(l.shakeSubtitle),
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
            const SizedBox(height: 20),
            Text(l.reportMediaLimits),
            const SizedBox(height: 16),
            Text(
              l.reportDraftNotice,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (!serviceLocator<IssueReportRepository>().configured) ...[
              const SizedBox(height: 20),
              Text(l.uploadNotConfigured),
            ],
            const SizedBox(height: 28),
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
