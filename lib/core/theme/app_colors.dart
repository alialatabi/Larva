import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────────────────
  static const Color bgBase     = Color(0xFF080A0E); // Screen backgrounds
  static const Color bgSurface  = Color(0xFF0F1117); // Cards, panels
  static const Color bgElevated = Color(0xFF171C26); // Modals, raised cards
  static const Color bgInput    = Color(0xFF1E2330); // Text fields, inner containers

  // ── Borders ─────────────────────────────────────────────────────
  static const Color borderSubtle  = Color(0xFF252B3A); // Hairlines, rest state
  static const Color borderDefault = Color(0xFF323847); // Standard card borders
  static const Color borderStrong  = Color(0xFF4A5268); // Focus rings, active

  // ── Text ────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFEAE8E3); // Headings, key data
  static const Color textSecondary = Color(0xFF8A8FA0); // Labels, descriptions
  static const Color textTertiary  = Color(0xFF565D72); // Placeholders, metadata

  // ── Semantic — The Economy's Visual Language ─────────────────────
  // Gold: ALL currency ($). Every $ in the app uses this color.
  static const Color gold       = Color(0xFFC9A54A);
  static const Color goldBright = Color(0xFFE8C86A); // Animated on balance increase
  static const Color goldDim    = Color(0xFF7A6228); // Historical/muted currency

  // Emerald: Profit, positive deltas, success states
  static const Color emerald      = Color(0xFF00C97A);
  static const Color emeraldBright = Color(0xFF00F593);

  // Crimson: Loss, negative deltas, danger states
  static const Color crimson      = Color(0xFFE63946);
  static const Color crimsonBright = Color(0xFFFF4757);

  // Supporting semantic colors
  static const Color sky    = Color(0xFF4A90D9); // Info, links, progress
  static const Color amber  = Color(0xFFF59E0B); // Warnings, approaching deadlines
  static const Color violet = Color(0xFF8B5CF6); // Partner program, premium tier

  // ── Semantic Surfaces ────────────────────────────────────────────
  static const Color emeraldSurface = Color(0xFF00140A);
  static const Color crimsonSurface = Color(0xFF1A0507);
  static const Color amberSurface   = Color(0xFF150D00);
  static const Color skySurface     = Color(0xFF060F1A);

  // ── Need Colors — The Life Layer ─────────────────────────────────
  static const Color needHunger     = Color(0xFFE8874A);
  static const Color needEnergy     = Color(0xFF4AE8C9);
  static const Color needHealth     = Color(0xFFE84A6A);
  static const Color needHappiness  = Color(0xFFE8D44A);
  static const Color needHousing    = Color(0xFF4A7AE8);
  static const Color needTransport  = Color(0xFFA0A8C0);
  static const Color needAmbition   = Color(0xFFC44AE8);

  // ── Utility ──────────────────────────────────────────────────────
  static Color needColor(int value) {
    if (value >= 70) return emerald;
    if (value >= 40) return amber;
    return crimson;
  }
}
