import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global app theme, driven entirely by [AppColor].
/// Plain `Text` defaults to Cairo, AppBars/snackbars/dialogs/inputs all pull
/// from the brand palette so screens stay consistent without per-widget styling.
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColor.backgroundColor,
  colorScheme: const ColorScheme.light(
    primary: AppColor.primaryColor,
    secondary: AppColor.accentColor,
    surface: AppColor.cardBackground,
    error: AppColor.expenseColor,
    onPrimary: AppColor.textWhite,
    onSecondary: AppColor.textWhite,
    onSurface: AppColor.textPrimary,
  ),
  textTheme: GoogleFonts.cairoTextTheme().apply(
    bodyColor: AppColor.textPrimary,
    displayColor: AppColor.textPrimary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.primaryColor,
    foregroundColor: AppColor.textWhite,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.cairo(
      color: AppColor.textWhite,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    iconTheme: const IconThemeData(color: AppColor.textWhite),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColor.accentColor,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColor.accentColor,
    foregroundColor: AppColor.textWhite,
  ),
  dividerTheme: const DividerThemeData(color: AppColor.dividerColor),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColor.secondaryColor,
    contentTextStyle: GoogleFonts.cairo(color: AppColor.textWhite),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColor.cardBackground,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    titleTextStyle: GoogleFonts.cairo(
      color: AppColor.textPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    contentTextStyle: GoogleFonts.cairo(color: AppColor.textSecondary),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.cardBackground,
    floatingLabelStyle: const TextStyle(color: AppColor.primaryColor),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.borderColor),
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.borderColor),
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.accentColor),
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
  ),
);
