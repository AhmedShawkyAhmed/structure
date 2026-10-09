import 'package:flutter/material.dart';
import 'package:structure/core/application/app.dart';
import 'package:structure/core/application/app_bootstrap.dart';

Future<void> main() async {
  await initializeApplication();
  runApp(MyApp());
}
