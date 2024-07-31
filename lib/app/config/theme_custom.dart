import 'package:flutter/material.dart';

class ThemeCustom {
  static ThemeData themeLight = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    fontFamily: 'Bold',

    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    )
  );
}
