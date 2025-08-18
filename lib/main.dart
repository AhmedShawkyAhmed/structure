import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_service/hive_service.dart';
import 'package:network_service/network_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:structure/core/application/app.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/network/custom_dio_factory.dart';
import 'package:structure/core/resources/app_colors.dart';
import 'package:structure/core/services/bloc_observer.dart';

late PackageInfo packageInfo;
String? fcmToken;

void main() async {
  // customError();
  WidgetsFlutterBinding.ensureInitialized();
  // 🔹 Lock orientation to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // 🔹 Set status bar color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.greyScale50, // your custom color
      statusBarIconBrightness: Brightness.dark, // optional
    ),
  );

  await HiveService.init();
  // await NotificationService.init(
  //   options: DefaultFirebaseOptions.currentPlatform,
  //   onClickAction: (String? payload) async {},
  // );
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  // fcmToken = await NotificationService.getFCMToken();
  await setupServiceLocator();
  CustomDioFactory.initialize();
  NetworkStatusService.instance.init();
  Bloc.observer = BlocObserverService();
  packageInfo = await PackageInfo.fromPlatform();

  runApp(MyApp());
}
