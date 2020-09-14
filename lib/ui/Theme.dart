import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color primaryColor = Color(0xFFFFFFFF); //Color(0xFFFFFFFF);
  static const Color secondaryColor = Color(0xFFF2C230);
  static const Color goodColor = Color(0xFF32C2F0);
  static const Color badColor = Color(0xFFF28030);

  static const Color backgroundColor = const Color(0xFF184059); //0xFFFF4580
  static const Color tabImageBorder = const Color(0xFFFFFFFF); // 0xFFFFD2CF
  static Color tabImageShadowColor =
      HSLColor.fromColor(backgroundColor).withLightness(0.7).toColor();
  static Color tabShadowColor =
      HSLColor.fromColor(backgroundColor).withLightness(1).toColor();

  static Color tabColor =
      HSVColor.fromColor(backgroundColor).withValue(_value - .05).toColor();

  static var _value = HSVColor.fromColor(backgroundColor).value;
  static var _top =
      HSVColor.fromColor(backgroundColor).withValue(_value - .05).toColor();
  static var _bottom =
      HSVColor.fromColor(backgroundColor).withValue(_value - .1).toColor();

  static var ScreenBackground = LinearGradient(
    colors: [
      _top,
      backgroundColor,
      backgroundColor,
      _bottom,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.15, 0.4, 1.0],
    tileMode: TileMode.clamp,
  );
}

class Dimens {
  const Dimens();

  static const imageWidth = 100.0;
  static const imageHeight = 100.0;

  static const buttonWidth = 60.0;
  static const buttonHeight = 60.0;
}

class TextStyles {
  const TextStyles();

  static const TextStyle tabPrimary = const TextStyle(
      color: Colors.primaryColor,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
      fontSize: 28.0);

  static const TextStyle tabSecondary = const TextStyle(
      color: Colors.primaryColor,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
      fontSize: 20.0);

  static const TextStyle tabTertiary = const TextStyle(
      color: Colors.primaryColor,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
      fontSize: 16.0);

  static const TextStyle tabLabel = const TextStyle(
      color: Colors.primaryColor,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
      fontSize: 16.0);
}

class Helper {
  static Widget horizontalBorder() {
    return Container(
      color: Colors.secondaryColor,
      width: 38.0,
      height: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}
