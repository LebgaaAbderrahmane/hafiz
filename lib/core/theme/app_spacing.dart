import 'package:flutter/material.dart';

/// Hafiz Design System — Spacing
///
/// 4px base grid system.
/// Use EdgeInsetsDirectional for RTL support.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double xxxxl = 40;
  static const double xxxxxl = 48;
  static const double xxxxxxl = 64;

  // ── Edge Insets (Directional for RTL) ──
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXXXL = EdgeInsets.all(xxxl);

  // ── Directional Padding ──
  static const EdgeInsetsDirectional paddingHorizontalSM =
      EdgeInsetsDirectional.symmetric(horizontal: sm);
  static const EdgeInsetsDirectional paddingHorizontalMD =
      EdgeInsetsDirectional.symmetric(horizontal: md);
  static const EdgeInsetsDirectional paddingHorizontalLG =
      EdgeInsetsDirectional.symmetric(horizontal: lg);
  static const EdgeInsetsDirectional paddingHorizontalXL =
      EdgeInsetsDirectional.symmetric(horizontal: xl);
  static const EdgeInsetsDirectional paddingHorizontalXXL =
      EdgeInsetsDirectional.symmetric(horizontal: xxl);

  static const EdgeInsetsDirectional paddingVerticalSM =
      EdgeInsetsDirectional.symmetric(vertical: sm);
  static const EdgeInsetsDirectional paddingVerticalMD =
      EdgeInsetsDirectional.symmetric(vertical: md);
  static const EdgeInsetsDirectional paddingVerticalLG =
      EdgeInsetsDirectional.symmetric(vertical: lg);
  static const EdgeInsetsDirectional paddingVerticalXL =
      EdgeInsetsDirectional.symmetric(vertical: xl);

  // ── Border Radius ──
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusCard = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusDialog = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(999));

  // ── Gaps (SizedBox shortcuts) ──
  static const SizedBox gapXS = SizedBox(height: xs);
  static const SizedBox gapSM = SizedBox(height: sm);
  static const SizedBox gapMD = SizedBox(height: md);
  static const SizedBox gapLG = SizedBox(height: lg);
  static const SizedBox gapXL = SizedBox(height: xl);
  static const SizedBox gapXXL = SizedBox(height: xxl);
  static const SizedBox gapXXXL = SizedBox(height: xxxl);

  static const SizedBox gapHorizontalXS = SizedBox(width: xs);
  static const SizedBox gapHorizontalSM = SizedBox(width: sm);
  static const SizedBox gapHorizontalMD = SizedBox(width: md);
  static const SizedBox gapHorizontalLG = SizedBox(width: lg);
  static const SizedBox gapHorizontalXL = SizedBox(width: xl);
  static const SizedBox gapHorizontalXXL = SizedBox(width: xxl);
}
