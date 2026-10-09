import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routing/app_routes.dart';
import '../../localization/generated/app_localizations.dart';
import 'issue_report.dart';

class ReportRouteObserver extends NavigatorObserver {
  String currentScreen = AppRoutes.home.path;

  void _remember(Route<dynamic>? route) {
    if (route is PageRoute && route.settings.name != null) {
      currentScreen = route.settings.name!;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _remember(route);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _remember(previousRoute);
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _remember(newRoute);
}

class IssueReportingController extends ChangeNotifier {
  IssueReportingController({
    required this.navigatorKey,
    SharedPreferencesAsync? preferences,
  }) : _preferences = preferences ?? SharedPreferencesAsync();
  final GlobalKey<NavigatorState> navigatorKey;
  final screenshotKey = GlobalKey();
  final routeObserver = ReportRouteObserver();
  final SharedPreferencesAsync _preferences;
  bool shakeEnabled = true;
  bool opening = false;
  bool ready = false;

  Future<void> initialize() async {
    try {
      shakeEnabled =
          await _preferences.getBool('issue_reporting.shake') ?? true;
    } on Object {
      shakeEnabled = true;
    }
    ready = true;
    notifyListeners();
  }

  Future<bool> setShakeEnabled({required bool enabled}) async {
    try {
      await _preferences.setBool('issue_reporting.shake', enabled);
      shakeEnabled = enabled;
      notifyListeners();
      return true;
    } on Object {
      return false;
    }
  }

  Future<void> openReporter() async {
    final navigator = navigatorKey.currentState;
    if (opening ||
        navigator == null ||
        routeObserver.currentScreen == AppRoutes.issueReport.path) {
      return;
    }
    opening = true;
    notifyListeners();
    try {
      final screen = routeObserver.currentScreen;
      var includeScreenshot = false;
      final agreed = await showDialog<bool>(
        context: navigator.context,
        builder: (context) {
          final l = AppLocalizations.of(context);
          return StatefulBuilder(
            builder: (context, update) => AlertDialog(
              title: Text(l.reportIssue),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.reportPrompt),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.includeScreenshot),
                    subtitle: Text(l.screenshotConsent),
                    value: includeScreenshot,
                    onChanged: (value) => update(() {
                      includeScreenshot = value ?? false;
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l.continueReport),
                ),
              ],
            ),
          );
        },
      );
      if (agreed != true || !navigator.mounted) {
        return;
      }
      XFile? screenshot;
      if (includeScreenshot) {
        try {
          // Let the dismissed consent overlay finish animating before capture.
          await Future<void>.delayed(const Duration(milliseconds: 300));
          await WidgetsBinding.instance.endOfFrame;
          final boundary = screenshotKey.currentContext?.findRenderObject();
          if (boundary is! RenderRepaintBoundary) {
            throw StateError('No frame');
          }
          final image = await boundary.toImage(pixelRatio: 1.5);
          try {
            final data = await image.toByteData(format: ui.ImageByteFormat.png);
            if (data == null) {
              throw StateError('No pixels');
            }
            screenshot = XFile.fromData(
              data.buffer.asUint8List(),
              name: 'screenshot.png',
              mimeType: 'image/png',
            );
          } finally {
            image.dispose();
          }
        } on Object {
          if (navigator.mounted) {
            ScaffoldMessenger.of(navigator.context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(navigator.context).screenshotFailed,
                ),
              ),
            );
          }
        }
      }
      if (!navigator.mounted) {
        return;
      }
      await navigator.pushNamed(
        AppRoutes.issueReport.path,
        arguments: IssueReportArguments(screen: screen, screenshot: screenshot),
      );
    } finally {
      opening = false;
      notifyListeners();
    }
  }
}
