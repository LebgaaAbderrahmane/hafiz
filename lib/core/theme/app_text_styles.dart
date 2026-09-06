import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Hafiz Design System — Typography
///
/// Arabic: Noto Sans Arabic (primary)
/// Latin: Inter
/// Qur'an text: Dedicated Qur'anic font (loaded separately)
abstract final class AppTextStyles {
  // ── Font Families ──
  static const String arabicFont = 'NotoSansArabic';
  static const String latinFont = 'Inter';

  // ── Display ──
  static const TextStyle display = TextStyle(
    fontFamily: latinFont,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  // ── H1 ──
  static const TextStyle h1 = TextStyle(
    fontFamily: latinFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // ── H2 ──
  static const TextStyle h2 = TextStyle(
    fontFamily: latinFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // ── H3 ──
  static const TextStyle h3 = TextStyle(
    fontFamily: latinFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ── Body Large ──
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: latinFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // ── Body ──
  static const TextStyle body = TextStyle(
    fontFamily: latinFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // ── Body Small ──
  static const TextStyle bodySmall = TextStyle(
    fontFamily: latinFont,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // ── Caption ──
  static const TextStyle caption = TextStyle(
    fontFamily: latinFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  // ── Label ──
  static const TextStyle label = TextStyle(
    fontFamily: latinFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // ── Button Large ──
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: latinFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── Button Medium ──
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: latinFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── Button Small ──
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: latinFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── Arabic Styles ──
  static const TextStyle arabicH1 = TextStyle(
    fontFamily: arabicFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle arabicBody = TextStyle(
    fontFamily: arabicFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.8,
    color: AppColors.textPrimary,
  );

  static const TextStyle arabicBodyLarge = TextStyle(
    fontFamily: arabicFont,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.8,
    color: AppColors.textPrimary,
  );

  // ── Quran Text (separate font for sacred text) ──
  static const TextStyle quranText = TextStyle(
    fontFamily: 'Amiri', // Dedicated Qur'anic font
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 2.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle quranTextSmall = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 2.0,
    color: AppColors.textPrimary,
  );
}
