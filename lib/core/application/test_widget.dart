import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:structure/core/application/app_bootstrap.dart';
import 'package:structure/core/resources/app_colors.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.h,
      decoration: const BoxDecoration(color: AppColors.black),
      child: Center(
        child: Text(
          'Version ${packageInfo.version}+${packageInfo.buildNumber}',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 2.r,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
