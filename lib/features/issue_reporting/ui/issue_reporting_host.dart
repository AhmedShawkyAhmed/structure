import 'dart:async';

import 'package:flutter/material.dart';

import '../data/issue_reporting_controller.dart';
import '../data/shake_service.dart';

class IssueReportingHost extends StatefulWidget {
  const IssueReportingHost({
    required this.controller,
    required this.child,
    super.key,
  });
  final IssueReportingController controller;
  final Widget child;

  @override
  State<IssueReportingHost> createState() => _IssueReportingHostState();
}

class _IssueReportingHostState extends State<IssueReportingHost>
    with WidgetsBindingObserver {
  final _shake = ShakeService();
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    widget.controller.addListener(_sync);
    _sync();
  }

  void _sync() {
    if (_foreground &&
        widget.controller.ready &&
        widget.controller.shakeEnabled &&
        !widget.controller.opening) {
      _shake.start(() => unawaited(widget.controller.openReporter()));
    } else {
      unawaited(_shake.stop());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_sync);
    unawaited(_shake.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    key: widget.controller.screenshotKey,
    child: widget.child,
  );
}
