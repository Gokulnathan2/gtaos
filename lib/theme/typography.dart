import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  static const String fontFamily = 'Raleway'; // Use your enterprise font here

  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 32,
    color: AppColors.darkBlue,
    letterSpacing: 0.2,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: AppColors.darkBlue,
    letterSpacing: 0.1,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: AppColors.darkBlue,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: AppColors.darkBlue,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.darkBlue,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: AppColors.disabledGray,
  );

  static TextTheme textTheme = TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    headlineLarge: heading1,
    headlineMedium: heading2,
    headlineSmall: heading3,
    titleLarge: heading2,
    titleMedium: heading3,
    titleSmall: bodyLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodySmall,
    bodySmall: caption,
    labelLarge: bodyLarge,
    labelMedium: bodySmall,
    labelSmall: caption,
  );
} 