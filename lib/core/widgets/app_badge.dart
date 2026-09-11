import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Status badge for labels like "Active", "Pass", "Weak", etc.
///
/// Always pair with icon + text (never color-only per design spec).
enum AppBadgeVariant { success, warning, error, info, neutral }

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.color,
    this.icon,
    this.size = AppBadgeSize.small,
  });

  final String label;
  final AppBadgeVariant variant;
  final Color? color;
  final IconData? icon;
  final AppBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, foregroundColor, iconData) = switch (variant) {
      AppBadgeVariant.success => (AppColors.successSurface, AppColors.success, Icons.check_circle_outline),
      AppBadgeVariant.warning => (AppColors.warningSurface, AppColors.warning, Icons.warning_amber_outlined),
      AppBadgeVariant.error => (AppColors.errorSurface, AppColors.error, Icons.error_outline),
      AppBadgeVariant.info => (AppColors.infoSurface, AppColors.info, Icons.info_outline),
      AppBadgeVariant.neutral => (AppColors.surfaceVariant, AppColors.textSecondary, null),
    };

    final effectiveBackgroundColor = color != null ? color!.withValues(alpha: 0.15) : backgroundColor;
    final effectiveForegroundColor = color ?? foregroundColor;
    final effectiveIcon = icon ?? iconData;
    final fontSize = switch (size) {
      AppBadgeSize.small => 12.0,
      AppBadgeSize.medium => 13.0,
    };
    final horizontalPadding = switch (size) {
      AppBadgeSize.small => AppSpacing.sm,
      AppBadgeSize.medium => AppSpacing.md,
    };
    final verticalPadding = switch (size) {
      AppBadgeSize.small => 2.0,
      AppBadgeSize.medium => 4.0,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: AppSpacing.radiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (effectiveIcon != null) ...[
            Icon(effectiveIcon, size: fontSize + 2, color: effectiveForegroundColor),
            SizedBox(width: horizontalPadding * 0.5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: effectiveForegroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum AppBadgeSize { small, medium }
