import 'package:flutter/material.dart';
import 'package:structure/core/routing/app_routes.dart';
import 'package:structure/core/shared/widgets/app_ui.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';

class UnKnownScreen extends StatelessWidget {
  const UnKnownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIconBadge(icon: Icons.explore_off_outlined, size: 72),
                const SizedBox(height: 24),
                Text(
                  l.pageNotFound,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home.path,
                    (_) => false,
                  ),
                  child: Text(l.backToHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
