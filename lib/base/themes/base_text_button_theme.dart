import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseTextButtonTheme {
  static final primaryLightButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color.fromARGB(255, 143, 143, 143),
      disabledForegroundColor: Colors.white,
      textStyle: GoogleFonts.inter().copyWith(fontSize: 16.0),
    ),
  );
  static final primaryDarkButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      disabledBackgroundColor: const Color.fromARGB(255, 143, 143, 143),
      disabledForegroundColor: Colors.white,
      textStyle: GoogleFonts.inter().copyWith(fontSize: 16.0),
    ),
  );
}
