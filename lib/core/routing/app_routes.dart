enum AppRoutes {
  unknown,
  splash,
  onBoarding,
  register,
  login,
  home;

  String get path => '/${name.toString()}';
}
