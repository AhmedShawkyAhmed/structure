import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:structure/core/application/test_widget.dart';
import 'package:structure/core/network/api_routes.dart';

Widget defaultAppBuilder(BuildContext context, Widget? child) {
  return SafeArea(
    top: false,
    child: Column(
      children: [
        Expanded(child: child ?? const SizedBox()),
        if (APIRoutes.environment != Environment.production) const TestWidget(),
      ],
    ),
  );
}
