import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryOrange,
      onPrimary: AppColors.white,
      secondary: AppColors.primaryGreen,
      onSecondary: AppColors.white,
      error: AppColors.errorRed,
      onError: AppColors.white,
      background: AppColors.white,
      onBackground: AppColors.darkBlue,
      surface: AppColors.white,
      onSurface: AppColors.darkBlue,
    ),
    scaffoldBackgroundColor: AppColors.white,
    textTheme: AppTypography.textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.white,
      elevation: 4,
      centerTitle: true,
      titleTextStyle: AppTypography.heading2.copyWith(color: AppColors.white),
      toolbarHeight: 64,
      shadowColor: AppColors.shadow,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.disabledGray;
          } else if (states.contains(MaterialState.pressed)) {
            return AppColors.primaryDarkGreen;
          }
          return AppColors.primaryOrange;
        }),
        foregroundColor: MaterialStateProperty.all(AppColors.white),
        elevation: MaterialStateProperty.all(2),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        textStyle: MaterialStateProperty.all(AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.white),
        foregroundColor: MaterialStateProperty.all(AppColors.primaryGreen),
        side: MaterialStateProperty.all(
          BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        textStyle: MaterialStateProperty.all(AppTypography.bodyLarge),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.disabledGray, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.disabledGray, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.errorRed, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.errorRed, width: 2),
      ),
      labelStyle: AppTypography.bodySmall,
      hintStyle: AppTypography.caption,
      errorStyle: AppTypography.caption.copyWith(color: AppColors.errorRed),
    ),
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 4,
      shadowColor: AppColors.shadow,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryOrange,
      foregroundColor: AppColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkBlue,
      contentTextStyle: AppTypography.bodyLarge.copyWith(color: AppColors.white),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.disabledGray,
      thickness: 1,
      space: 24,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(AppColors.primaryGreen),
      checkColor: MaterialStateProperty.all(AppColors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(AppColors.primaryGreen),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(AppColors.primaryGreen),
      trackColor: MaterialStateProperty.all(AppColors.primaryDarkGreen.withOpacity(0.5)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryOrange,
      linearTrackColor: AppColors.disabledGray,
      circularTrackColor: AppColors.disabledGray,
    ),
    // Add more component themes as needed
  );
} 