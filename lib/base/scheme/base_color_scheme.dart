import 'package:flutter/material.dart';

class BaseColorScheme {
  static ColorScheme primaryLightColorScheme = ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.grey.shade800,
    tertiary: Colors.grey.shade700,
  );

  static ColorScheme primaryDarkColorScheme = ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.grey.shade100,
    tertiary: Colors.grey.shade200,
  );
}
