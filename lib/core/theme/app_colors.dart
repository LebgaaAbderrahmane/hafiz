import 'package:flutter/material.dart';

/// Hafiz Design System — Colors
///
/// Deep Qur'anic green primary with warm neutral grayscale.
/// All semantic states include icon + text, never color-only.
abstract final class AppColors {
  // ── Primary ──
  static const Color primary = Color(0xFF1A6B4F);
  static const Color primaryLight = Color(0xFF2D9D78);
  static const Color primaryDark = Color(0xFF0E4A36);
  static const Color primarySurface = Color(0xFFE8F5EE);

  // ── Secondary ──
  static const Color secondary = Color(0xFF4A90D9);
  static const Color secondaryLight = Color(0xFF6BAAE8);
  static const Color secondaryDark = Color(0xFF2D6CB5);

  // ── Neutral ──
  static const Color background = Color(0xFFF8F7F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF2F1EE);
  static const Color border = Color(0xFFE5E4E0);
  static const Color borderLight = Color(0xFFF0EFEC);
  static const Color divider = Color(0xFFE5E4E0);

  // ── Text ──
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic ──
  static const Color success = Color(0xFF2D9D78);
  static const Color successSurface = Color(0xFFE8F5EE);
  static const Color warning = Color(0xFFD4A843);
  static const Color warningSurface = Color(0xFFFEF7E6);
  static const Color error = Color(0xFFD44343);
  static const Color errorSurface = Color(0xFFFDE8E8);
  static const Color info = Color(0xFF4A90D9);
  static const Color infoSurface = Color(0xFFE8F0FA);

  // ── Memorization Status ──
  static const Color memorized = Color(0xFF2D9D78);
  static const Color inProgress = Color(0xFF4A90D9);
  static const Color needsRevision = Color(0xFFD4A843);
  static const Color weak = Color(0xFFD44343);
  static const Color notStarted = Color(0xFF9E9E9E);

  // ── Tasmi' Outcome ──
  static const Color tasmiPass = Color(0xFF2D9D78);
  static const Color tasmiNeedsRevision = Color(0xFFD4A843);
  static const Color tasmiFail = Color(0xFFD44343);

  // ── Attendance ──
  static const Color present = Color(0xFF2D9D78);
  static const Color late = Color(0xFFD4A843);
  static const Color absent = Color(0xFFD44343);
  static const Color excused = Color(0xFF4A90D9);
}
