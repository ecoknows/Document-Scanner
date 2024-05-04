import 'package:document_scanner/base/scheme/base_color_scheme.dart';
import 'package:document_scanner/base/themes/base_input_decoration_theme.dart';
import 'package:document_scanner/base/themes/base_text_button_theme.dart';
import 'package:document_scanner/base/themes/base_text_theme.dart';
import 'package:flutter/material.dart';

class BaseThemeData {
  static final primaryLightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: BaseColorScheme.primaryLightColorScheme,
    textTheme: BaseTextTheme.primaryLightTextTheme,
    textButtonTheme: BaseTextButtonTheme.primaryLightButtonTheme,
    inputDecorationTheme:
        BaseInputDecorationTheme.primaryLightInputDecorationTheme,
  );
  static final primaryDarkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: BaseColorScheme.primaryDarkColorScheme,
    textTheme: BaseTextTheme.primaryDarkTextTheme,
    textButtonTheme: BaseTextButtonTheme.primaryDarkButtonTheme,
    inputDecorationTheme:
        BaseInputDecorationTheme.primaryDarkInputDecorationTheme,
  );
}
