import 'package:flutter/material.dart';

class FluTheme extends ChangeNotifier {
  var primaryColor = Color(0xFFFFFFFF);
  var secondaryColor = Color(0xFFF2C230);
  var backgroundColor = Color(0xFF184059);
  var tabImageBorder = Color(0xFFFFFFFF);
  var goodColor = Color(0xFF32C2F0);
  var badColor = Color(0xFFF28030);

  Color tabColor;
  LinearGradient screenBackgroundGradient;
  TextStyle tabPrimaryStyle;
  TextStyle tabSecondaryStyle;
  TextStyle tabTertiaryStyle;
  TextStyle tabLabelStyle;

  FluTheme() {
    var value = HSVColor.fromColor(backgroundColor).value;
    var top = HSVColor.fromColor(backgroundColor).withValue(value - .05).toColor();
    var bottom = HSVColor.fromColor(backgroundColor).withValue(value - .1).toColor();

    // generate tab and background from our background color
    tabColor = HSVColor.fromColor(backgroundColor).withValue(value - .05).toColor();
    screenBackgroundGradient = LinearGradient(
      colors: [
        top,
        backgroundColor,
        backgroundColor,
        bottom,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.15, 0.4, 1.0],
      tileMode: TileMode.clamp,
    );

    tabPrimaryStyle =
        TextStyle(color: primaryColor, fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 28.0);
    tabSecondaryStyle =
        TextStyle(color: primaryColor, fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 20.0);
    tabTertiaryStyle =
        TextStyle(color: primaryColor, fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 16.0);
    tabLabelStyle = TextStyle(color: primaryColor, fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 16.0);
  }

  // TODO: if we want to change theme dynamically, implement set() methods and use
  // ChangeNotifier.notifyListeners()

  Widget buildHorizontalBorder() {
    return Container(
      color: secondaryColor,
      width: 38.0,
      height: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }

  // generates a ThemeData usable by Material based on our own primary and secondary colors
  ThemeData get themeData {
    var txtTheme = ThemeData.dark().textTheme.apply(fontFamily: 'Poppins');
    var txtColor = txtTheme.bodyText1.color;
    var colorScheme = ColorScheme(
        brightness: Brightness.dark,
        primary: primaryColor,
        primaryVariant: primaryColor,
        secondary: secondaryColor,
        secondaryVariant: secondaryColor,
        background: backgroundColor,
        surface: backgroundColor,
        onBackground: txtColor,
        onSurface: txtColor,
        onError: primaryColor,
        onPrimary: primaryColor,
        onSecondary: primaryColor,
        error: badColor);

    var t = ThemeData.from(textTheme: txtTheme, colorScheme: colorScheme).copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonColor: primaryColor,
        cursorColor: primaryColor,
        highlightColor: primaryColor,
        toggleableActiveColor: primaryColor);

    return t;
  }
}
