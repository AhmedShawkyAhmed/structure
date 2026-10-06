import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:structure/core/application/test_widget.dart';
import 'package:structure/core/network/api_routes.dart';
import 'package:twist_music_player/twist_music_player.dart';

Widget defaultAppBuilder(BuildContext context, Widget? child) {
  final showEnvironmentBar = APIRoutes.environment != Environment.production;
  return TwistPlayerHost(
    bottomInset: showEnvironmentBar ? 2.h : 0,
    child: SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(child: child ?? const SizedBox()),
          if (showEnvironmentBar) const TestWidget(),
        ],
      ),
    ),
  );
}
