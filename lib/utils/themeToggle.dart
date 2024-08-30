import 'package:flutter/material.dart';

class ThemeToggle {
  ThemeData lightTheme = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.light,
    useMaterial3: true,
  );

  ThemeData darkTheme = ThemeData(
    fontFamily: 'Lato',
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
