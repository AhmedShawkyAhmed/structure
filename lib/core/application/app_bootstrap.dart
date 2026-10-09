import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_service/hive_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../features/issue_reporting/data/issue_reporting_setup.dart';
import '../../features/twist/data/twist_music_setup.dart';
import '../di/service_locator.dart';
import '../network/custom_dio_factory.dart';
import '../resources/app_colors.dart';
import '../services/bloc_observer.dart';

late PackageInfo packageInfo;

Future<void> initializeApplication() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.greyScale50,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await HiveService.init();
  await CustomDioFactory.initialize();
  await setupServiceLocator();
  packageInfo = await PackageInfo.fromPlatform();
  Bloc.observer = BlocObserverService();
  await initializeTwistMusicPlayer();
  await initializeIssueReporting(serviceLocator);
}
