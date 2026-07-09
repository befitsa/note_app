import 'package:flutter/material.dart';

/// Centralised colour palette for NotesHub.
///
/// Keeping every colour here means the whole app can be re-themed by
/// editing a single file.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF02457A);
  static const Color primaryDark = Color(0xFF001B48);
  static const Color secondary = Color(0xFF97CADB);
  static const Color accent = Color(0xFFD6E8EE);

  // Light theme
  static const Color lightBackground = Color(0xFFF5FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF102A43);
  static const Color lightTextSecondary = Color(0xFF486581);
  static const Color lightBorder = Color(0xFFD6E8EE);

  // Dark theme
  static const Color darkBackground = Color(0xFF001B48);
  static const Color darkSurface = Color(0xFF022B52);
  static const Color darkTextPrimary = Color(0xFFD6E8EE);
  static const Color darkTextSecondary = Color(0xFF97CADB);
  static const Color darkBorder = Color(0xFF02457A);

  // Semantic
  static const Color danger = Color(0xFFE57373);
  static const Color warning = Color(0xFFF2C14E);
  static const Color success = Color(0xFF4FAF75);

  // Note colour swatches available in the colour picker.
  static const List<Color> noteSwatches = [
    Color(0xFFFFFFFF),
    Color(0xFFD6E8EE),
    Color(0xFF97CADB),
    Color(0xFFB8DCE8),
    Color(0xFFA7C7E7),
    Color(0xFF02457A),
  ];

  static const List<Color> gradientHeaderLight = [
    Color(0xFF001B48),
    Color(0xFF02457A),
  ];

  static const List<Color> gradientStartup = [
    Color(0xFF001B48),
    Color(0xFF02457A),
  ];

  static const List<Color> gradientHeaderDark = [
    Color(0xFF001B48),
    Color(0xFF02457A),
  ];
}

const Color kcPrimaryColor = Color(0xFF02457A);
const Color kcPrimaryColorDark = Color(0xFF001B48);
const Color kcDarkGreyColor = Color(0xFF001B48);
const Color kcMediumGrey = Color(0xFF486581);
const Color kcLightGrey = Color(0xFF97CADB);
const Color kcVeryLightGrey = Color(0xFFD6E8EE);
const Color kcBackgroundColor = kcDarkGreyColor;