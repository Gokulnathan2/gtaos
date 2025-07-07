import 'package:flutter/material.dart';

/// Enterprise Brand Color Palette
class AppColors {
  // Brand Primary Colors
  static const Color primaryOrange = Color(0xFFcf8103); // Brand accent, CTAs
  static const Color primaryGreen = Color(0xFF89c236); // Success, confirmations
  static const Color primaryDarkGreen = Color(0xFF669b16); // Hover, active
  static const Color disabledGray = Color(0xFFAFBCC7); // Inactive elements
  static const Color darkBlue = Color(0xFF2E3953); // Text, headers, nav

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryGreen, primaryDarkGreen],
  );

  // Additional Colors (for feedback, backgrounds, etc.)
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color errorRed = Color(0xFFD32F2F); // Standard error
  static const Color warningOrange = primaryOrange;
  static const Color successGreen = primaryGreen;
  static const Color infoBlue = Color(0xFF1976D2);

  // Shadows
  static const Color shadow = Color(0x1A2E3953); // 10% opacity dark blue
} 