enum AppRoutes {
  unknown,
  deviceInfo,
  splash,
  onBoarding,
  register,
  login,
  home;

  String get path => '/${name.toString()}';
}
