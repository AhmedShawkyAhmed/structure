import 'package:flutter/material.dart';
import 'package:structure/core/resources/hex_color.dart';

class AppColors {
  AppColors._();

  /// ----------------------------------------------- \\\
  static const primary = Color(0xff7210FF);
  static const grey = Color(0xffEEEEEE);
  static const grey2 = Color(0xff888888);
  static const grey3 = Color(0xffE0E0E0);
  static const darkGrey = Color(0xff212121);
  static const grey4 = Color(0xff9E9E9E);
  static const hover = Color(0xffCBA8FF);
  static const shadow = Color(0xff000012);
  static const black = Color(0xff000000);
  static const white = Color(0xffFFFFFF);
  static const green = Color(0xff3ED18B);
  static const red = Color(0xffF3513E);
  static const yellow = Color(0xffFFEA62);
  static const orange = Color(0xffff860f);
  static const transparent = Color(0x00ffffff);


  /// Main Colors
  /// Primary
  static final primaryColor500 = HexColor('7210FF');
  static final primaryColor400 = HexColor('8E40FF');
  static final primaryColor300 = HexColor('AA70FF');
  static final primaryColor200 = HexColor('C79FFF');
  static final primaryColor100 = HexColor('F1E7FF');

  /// ----------------------------------------------- \\\

  /// Secondary
  static final secondaryColor500 = HexColor('FFD300');
  static final secondaryColor400 = HexColor('FFDC33');
  static final secondaryColor300 = HexColor('FFE566');
  static final secondaryColor200 = HexColor('FFED99');
  static final secondaryColor100 = HexColor('FFFBE6');

  /// ----------------------------------------------- \\\

  /// Alert & Status
  static final success = HexColor('4ADE80');
  static final info = HexColor('246BFD');
  static final warning = HexColor('FACC15');
  static final error = HexColor('F75555');
  static final disabled = HexColor('D8D8D8');
  static final disabledButton = HexColor('6F3ABB');

  /// ----------------------------------------------- \\\

  /// GreyScale
  static final greyScale900 = HexColor('212121');
  static final greyScale800 = HexColor('424242');
  static final greyScale700 = HexColor('616161');
  static final greyScale600 = HexColor('757575');
  static final greyScale500 = HexColor('9E9E9E');
  static final greyScale400 = HexColor('BDBDBD');
  static final greyScale300 = HexColor('E0E0E0');
  static final greyScale200 = HexColor('EEEEEE');
  static final greyScale100 = HexColor('F5F5F5');
  static final greyScale50 = HexColor('F7F7F7');

  static final hintColor = HexColor('CCCCCC');

  /// ----------------------------------------------- \\\

  /// Gradient Orange2
  /// Linear
  static final gradientOra1 = HexColor('E5BA48');
  static final gradientOra2 = HexColor('D5982F');

  /// Gradients
  /// Gradient Purple
  /// Linear
  static final gradientPurple1 = HexColor('7210FF');
  static final gradientPurple2 = HexColor('9D59FF');

  /// Gradient Yellow
  /// Linear
  static final gradientYellow1 = HexColor('FACC15');
  static final gradientYellow2 = HexColor('FFE580');

  /// Gradient Blue
  /// Linear
  static final gradientBlue1 = HexColor('335EF7');
  static final gradientBlue2 = HexColor('5F82FF');

  /// Gradient Green
  /// Linear
  static final gradientGreen1 = HexColor('22BB9C');
  static final gradientGreen2 = HexColor('35DEBC');

  /// Gradient Orange
  /// Linear
  static final gradientOrange1 = HexColor('FB9400');
  static final gradientOrange2 = HexColor('FFAB38');

  /// Gradient Red
  /// Linear
  static final gradientRed1 = HexColor('FF4D67');
  static final gradientRed2 = HexColor('FF8A9B');
  static final regGradient = HexColor("FF6E76");

  /// ----------------------------------------------- \\\

  /// Dark Colors
  static final dark1 = HexColor('181A20');
  static final dark2 = HexColor('1F222A');
  static final dark3 = HexColor('35383F');

  /// ----------------------------------------------- \\\

  /// Others
  static final whiteColor = HexColor('FFFFFF');
  static final blackColor = HexColor('000000');
  static final redColor = HexColor('F44336');
  static final pinkColor = HexColor('E91E63');
  static final purpleColor = HexColor('9C27B0');
  static final deepPurpleColor = HexColor('673AB7');
  static final indigoColor = HexColor('3F51B5');
  static final blueColor = HexColor('2196F3');
  static final lightBlueColor = HexColor('03A9F4');
  static final cyanColor = HexColor('00BCD4');
  static final tealColor = HexColor('009688');
  static final greenColor = HexColor('4CAF50');
  static final lightGreenColor = HexColor('8BC34A');
  static final limeColor = HexColor('CDDC39');
  static final yellowColor = HexColor('FFEB3B');
  static final amberColor = HexColor('FFC107');
  static final orangeColor = HexColor('FF9800');
  static final gold = HexColor('FFD700');
  static final deepOrangeColor = HexColor('FF5722');
  static final brownColor = HexColor('795548');
  static final blueGreyColor = HexColor('607D8A');
  static final  lightGrey = HexColor('E5E5E5');

  /// ----------------------------------------------- \\\

  /// Background
  static final purpleBg = HexColor('F4ECFF');
  static final yellow2Bg = HexColor('FFF7EB');
  static final lightYellowBg = HexColor('FFFBED');
  static final lightBlueBg = HexColor('EFF3FF');
  static final lightBlue2Bg = HexColor('EBFAFC');
  static final lightRedBg = HexColor('FFF2F2');
  static final lightGreenBg = HexColor('F1F9F1');
  static final blueBg = HexColor('F6FAFD');
  static final greenBg = HexColor('F2FFFC');
  static final orangeBg = HexColor('FFF8ED');
  static final pinkBg = HexColor('FFF5F5');
  static final yellowBg = HexColor('FFFEE0');

  /// ----------------------------------------------- \\\

  /// Transparent
  static final purpleTransparent = HexColor('7210FF');
  static final blueTransparent = HexColor('335EF7');
  static final orangeTransparent = HexColor('FF9800');
  static final yellowTransparent = HexColor('FACC15');
  static final redTransparent = HexColor('F75555');
  static final greenTransparent = HexColor('4CAF50');
  static final cyanTransparent = HexColor('00BCD4');

  /// ----------------------------------------------- \\\
  /// Card Shadows
  static final cardShadowOne = HexColor('04060F');
  static final cardShadowTwo = HexColor('04060F');
  static final cardShadowThree = HexColor('04060F');

  /// ----------------------------------------------- \\\
  static final alertsAndStatusError = HexColor('F75555');

  static final greyText = HexColor('888888');
}