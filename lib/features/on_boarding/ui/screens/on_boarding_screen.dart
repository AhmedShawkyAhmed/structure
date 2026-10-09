import 'package:flutter/material.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).onboardingFeatureTitle),
      ),
      body: const Placeholder(),
    );
  }
}
