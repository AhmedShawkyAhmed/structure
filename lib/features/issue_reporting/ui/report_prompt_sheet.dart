import 'package:flutter/material.dart';

import '../../../core/resources/app_theme.dart';
import '../../../core/shared/widgets/app_ui.dart';
import '../../localization/generated/app_localizations.dart';

/// Null cancels; a bool continues with the selected screenshot preference.
class ReportPromptSheet extends StatefulWidget {
  const ReportPromptSheet({super.key});

  @override
  State<ReportPromptSheet> createState() => _ReportPromptSheetState();
}

class _ReportPromptSheetState extends State<ReportPromptSheet> {
  bool _includeScreenshot = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppIconBadge(icon: Icons.bug_report_outlined),
                const Spacer(),
                IconButton.filledTonal(
                  tooltip: l.cancel,
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.canvas,
                    foregroundColor: AppTheme.muted,
                  ),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              l.reportIssue,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(l.reportPrompt, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            AppSectionCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  l.includeScreenshot,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    l.screenshotConsent,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                value: _includeScreenshot,
                onChanged: (value) =>
                    setState(() => _includeScreenshot = value ?? false),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, _includeScreenshot),
                icon: const Icon(Icons.edit_note_rounded),
                label: Text(l.continueReport),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
