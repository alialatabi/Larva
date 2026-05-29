import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // ── Display (Syne) — Hero numbers, screen titles ─────────────────
  static TextStyle get displayXL => GoogleFonts.syne(
    fontSize: 40, fontWeight: FontWeight.w700,
    height: 1.1, color: AppColors.textPrimary, letterSpacing: -0.02,
  );
  static TextStyle get displayL => GoogleFonts.syne(
    fontSize: 32, fontWeight: FontWeight.w700,
    height: 1.15, color: AppColors.textPrimary,
  );
  static TextStyle get displayM => GoogleFonts.syne(
    fontSize: 24, fontWeight: FontWeight.w700,
    height: 1.2, color: AppColors.textPrimary,
  );

  // ── Headings (DM Sans) ───────────────────────────────────────────
  static TextStyle get headingL => GoogleFonts.dmSans(
    fontSize: 20, fontWeight: FontWeight.w600,
    height: 1.3, color: AppColors.textPrimary,
  );
  static TextStyle get headingM => GoogleFonts.dmSans(
    fontSize: 17, fontWeight: FontWeight.w600,
    height: 1.35, color: AppColors.textPrimary,
  );
  static TextStyle get headingS => GoogleFonts.dmSans(
    fontSize: 15, fontWeight: FontWeight.w500,
    height: 1.4, color: AppColors.textPrimary,
  );

  // ── Body (DM Sans) ───────────────────────────────────────────────
  static TextStyle get bodyL => GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.textPrimary,
  );
  static TextStyle get bodyM => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.textSecondary,
  );
  static TextStyle get bodyS => GoogleFonts.dmSans(
    fontSize: 12, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.textSecondary,
  );

  // ── Data (DM Mono) — ALL financial numbers ───────────────────────
  static TextStyle get dataL => GoogleFonts.dmMono(
    fontSize: 20, fontWeight: FontWeight.w500,
    height: 1.2, color: AppColors.textPrimary,
  );
  static TextStyle get dataM => GoogleFonts.dmMono(
    fontSize: 16, fontWeight: FontWeight.w400,
    height: 1.3, color: AppColors.textPrimary,
  );
  static TextStyle get dataS => GoogleFonts.dmMono(
    fontSize: 13, fontWeight: FontWeight.w400,
    height: 1.4, color: AppColors.textPrimary,
  );

  // ── Label ─────────────────────────────────────────────────────────
  static TextStyle get label => GoogleFonts.dmSans(
    fontSize: 11, fontWeight: FontWeight.w500,
    height: 1.4, letterSpacing: 0.08, color: AppColors.textSecondary,
  );
  static TextStyle get labelCaps => GoogleFonts.dmSans(
    fontSize: 11, fontWeight: FontWeight.w500,
    height: 1.4, letterSpacing: 0.08, color: AppColors.textTertiary,
  );
}
