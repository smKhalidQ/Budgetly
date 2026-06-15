import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography rule for the whole app:
///   • Cairo  → all labels, titles and body text
///   • Poppins → numeric values (amounts, percentages, currency figures)
///
/// Plain text already uses `GoogleFonts.cairo(...)` inline (and the global
/// `textTheme` defaults to Cairo). Use [AppTextStyle.number] anywhere a number
/// is shown so digits stay visually consistent across screens.
class AppTextStyle {
  const AppTextStyle._();

  static TextStyle number({
    required double size,
    FontWeight weight = FontWeight.w700,
    Color color = AppColor.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
