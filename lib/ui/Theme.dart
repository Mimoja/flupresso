import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color primaryColor = Color(0xFFFFFFFF); //Color(0xFFFFFFFF);
  static const Color secondaryColor = Color(0xFFF2C230);
  static const Color goodColor = Color(0xFF32C2F0);
  static const Color badColor = Color(0xFFF28030);

  static const Color tabPageBackground = const Color(0xFFFFFFFF);
  static const Color tabBackground = const Color(0xFF184059); //0xFFFF4580
  static Color tabImageBackground = tabBackground;
  static const Color tabImageBorder = const Color(0xFFFFFFFF); // 0xFFFFD2CF
  static Color tabImageShadowColor =
      HSLColor.fromColor(tabBackground).withLightness(0.7).toColor();
  static Color tabShadowColor =
      HSLColor.fromColor(tabBackground).withLightness(1).toColor();

  static Color tabHighlightColor = secondaryColor;
}

class Dimens {
  const Dimens();

  static const imageWidth = 100.0;
  static const imageHeight = 100.0;
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
}
