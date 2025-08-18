import 'package:flutter/material.dart';
import 'package:network_service/network_service.dart';
import 'package:ui_kit/ui_kit.dart';

extension DefaultException on DefaultSnackbar {
  static Widget showNetworkError(NetworkExceptions exception) {
    final details = exception.networkErrorDetails;
    DefaultSnackbar.showError(
      details.message ?? 'An unknown error occurred',
      statusCode: details.statusCode,
    );
    return const SizedBox.shrink();
  }
}
