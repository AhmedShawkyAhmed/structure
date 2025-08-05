import 'package:flutter/material.dart';
import 'package:structure/core/resources/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.android_rounded,
          size: 100,
          color: AppColors.blueColor,
        ),
      ),
    );
  }
}
