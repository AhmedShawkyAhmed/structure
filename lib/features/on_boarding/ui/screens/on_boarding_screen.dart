import 'package:flutter/material.dart';
import 'package:structure/core/routing/app_routes.dart';
import 'package:structure/core/shared/widgets/app_ui.dart';
import 'package:structure/features/home/data/app_features.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.onboardingFeatureTitle)),
      body: AppPageBody(
        maxWidth: 640,
        children: [
          AppHeroCard(
            title: l.onboardingTitle,
            subtitle: l.onboardingSubtitle,
            icon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: 24),
          for (final feature in appFeatures.take(3)) ...[
            AppSectionCard(
              child: Row(
                children: [
                  AppIconBadge(
                    icon: feature.icon,
                    color: feature.color,
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature.title(l),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          feature.subtitle(l),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: Text(l.getStarted),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              AppRoutes.register.path,
            ),
            child: Text(l.registerFeatureTitle),
          ),
        ],
      ),
    );
  }
}
