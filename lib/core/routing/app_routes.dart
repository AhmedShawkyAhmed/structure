enum AppRoutes {
  unknown,
  deviceInfo,
  twist,
  issueReporting,
  issueReport,
  splash,
  onBoarding,
  register,
  login,
  home;

  String get path => '/${name.toString()}';
}
