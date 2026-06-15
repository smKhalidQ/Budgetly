import 'package:flutter/material.dart';

/// Single source of truth for the app's colors.
/// Calm, muted "money tracker" palette: slate-blue for trust, one teal accent,
/// desaturated semantic colors for income/expense so nothing screams at the user.
class AppColor {
  // ── Brand ──────────────────────────────────────────────────────────────
  static const Color primaryColor = Color(0xFF3B566D); // slate blue
  static const Color secondaryColor = Color(0xFF2A3F50); // deep slate
  static const Color accentColor = Color(0xFF4F959D); // teal — the one accent

  // Header gradient (start = secondaryColor, end = deeper slate).
  static const Color headerGradientStart = secondaryColor;
  static const Color headerGradientEnd = Color(0xFF16242F);

  // ── Semantic ───────────────────────────────────────────────────────────
  static const Color incomeColor = Color(0xFF52A07D); // calm sage green
  static const Color expenseColor =
      Color(0xFFDC6B6B); // muted coral — spend / over-budget / destructive
  static const Color warningColor = Color(0xFFE0A458); // muted amber — caution

  static const Color categoryOthers = Color(0xFF90A4AE);

  // ── Surfaces ───────────────────────────────────────────────────────────
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color surfaceMuted =
      Color(0xFFEEF1F5); // chips / fills / progress tracks
  static const Color backgroundGlass = Color(0x1A3B566D);
  static const Color backgroundCardShadow = Color(0x14000000);

  // ── Text ───────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF263238);
  static const Color textSecondary = Color(0xFF78909C);
  static const Color textTertiary = Color(0xFF9AA8B2); // hints / disabled
  static const Color textWhite = Colors.white;

  // ── Bottom nav ─────────────────────────────────────────────────────────
  static const Color bottomWhiteBackGround = Colors.white;
  static const Color bottomBarActive = primaryColor;
  static const Color bottomBarInactive = Color(0xFFB0BEC5);

  // ── Lines ──────────────────────────────────────────────────────────────
  static const Color dividerColor = Color(0xFFE6EBEF);
  static const Color borderColor = Color(0xFFDDE3E8);
  static const Color lightGray = Color(0x333B566D);
}
