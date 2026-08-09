import 'package:flutter/material.dart';

/// Palette officielle MusicScroll.
///
/// Toutes les couleurs de l'application passent par cette classe.
abstract final class AppColors {
  AppColors._();

  // =========================
  // Base
  // =========================

  static const Color background = Color(0xFF101214);
  static const Color surface = Color(0xFF1B1F24);
  static const Color card = Color(0xFF252B33);

  // =========================
  // Primary (vert emeraude MusicScroll)
  // =========================

  static const Color primary = Color(0xFF457CE1);
  static const Color primaryLight = Color(0xFF6F9BF0);
  static const Color primaryDark = Color(0xFF2F63C3);
  // =========================
  // Secondary
  // =========================

  static const Color secondary = primary;
  // =========================
  // Status
  // =========================

  static const Color success = Color(0xFF00C878);

  static const Color warning = Color(0xFFFFB300);

  static const Color error = Color(0xFFE53935);

  static const Color info = primary;

  // =========================
  // Text
  // =========================

  static const Color textPrimary = Color(0xFFF5F5F5);

  static const Color textSecondary = Color(0xFFA8B0BA);

  static const Color textDisabled = Color(0xFF707780);

  // =========================
  // Divider
  // =========================

  static const Color divider = Color(0xFF3B424C);

  // =========================
  // Misc
  // =========================

  static const Color transparent = Colors.transparent;

  static const Color white = Colors.white;

  static const Color black = Colors.black;

  // =========================
  // Instrument colors
  // =========================

  static const Color guitar = primary;

  static const Color bass = primary;

  static const Color ukulele = Color(0xFFFFB300);

  static const Color violin = Color(0xFFB05CFF);

  // =========================
  // Tuner colors
  // =========================

  static const Color inTune = Color(0xFF00C878);

  static const Color almostTune = Color(0xFFFFB300);

  static const Color outTune = Color(0xFFE53935);
}