import 'package:flutter/material.dart';
import 'app_spacing.dart';

/// Shortcut for vertical gaps between widgets.
abstract final class Gap {
  static const SizedBox xs = SizedBox(height: AppSpacing.xs);
  static const SizedBox s = SizedBox(height: AppSpacing.sm);
  static const SizedBox m = SizedBox(height: AppSpacing.md);
  static const SizedBox l = SizedBox(height: AppSpacing.lg);
  static const SizedBox xl = SizedBox(height: AppSpacing.xl);
  static const SizedBox xxl = SizedBox(height: AppSpacing.xxl);
  static const SizedBox xxxl = SizedBox(height: AppSpacing.xxxl);
}

/// Border radius values.
abstract final class AppBorderRadius {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 20;
}
