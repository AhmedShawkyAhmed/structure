import 'package:flutter/material.dart';
import 'package:structure/core/resources/app_theme.dart';
import 'package:structure/core/shared/widgets/app_ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIconBadge(icon: Icons.layers_rounded, size: 88),
          const SizedBox(height: 24),
          Text('Structure', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 28),
          const SizedBox(
            width: 40,
            child: LinearProgressIndicator(color: AppTheme.violet),
          ),
        ],
      ),
    ),
  );
}
