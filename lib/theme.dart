import 'package:flutter/material.dart';

class GameTheme {
  static const Color primaryColor = Color(0xFF4CAF50); // Grass Green

  static const Color backboardColor = Color(0xFFA0522D); //  Brown

  static const Color secondryColor = Color(0xFFFF5722); // Deep Orange-Red

  static const Color discoveredCellColor = Color(0xFFFFEB3B); // Yellow

  static const Color disabledColor = Color(0xFFC2CFD9);

  static const Color alertColor = Color(0xFFFF1744); // Bright Red (alert)
  static ThemeData get lightTheme {
    return ThemeData().copyWith(
      brightness: Brightness.light,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 2),
          alignment: Alignment.center,
          side: const BorderSide(color: primaryColor, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          disabledForegroundColor: disabledColor,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 2),
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          side: const BorderSide(color: Colors.white, width: 2),
          disabledForegroundColor: disabledColor,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
