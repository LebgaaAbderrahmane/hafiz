import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Standard card component.
///
/// Follows design spec: "Avoid excessive cards."
/// Use for content that benefits from visual separation.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? AppSpacing.radiusCard,
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

/// Compact card for KPI metrics on dashboards.
class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.trend,
    this.trendLabel,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final double? trend;
  final String? trendLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: color ?? AppColors.primary),
                AppSpacing.gapHorizontalSM,
              ],
              Expanded(
                child: Text(label, style: AppTextStyles.caption),
              ),
            ],
          ),
          AppSpacing.gapSM,
          Text(value, style: AppTextStyles.h2),
          if (trend != null) ...[
            AppSpacing.gapXS,
            Row(
              children: [
                Icon(
                  trend! >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: trend! >= 0 ? AppColors.success : AppColors.error,
                ),
                AppSpacing.gapHorizontalXS,
                Text(
                  '${trend! >= 0 ? '+' : ''}${trend!.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: trend! >= 0 ? AppColors.success : AppColors.error,
                  ),
                ),
                if (trendLabel != null) ...[
                  AppSpacing.gapHorizontalXS,
                  Text(trendLabel!, style: AppTextStyles.caption),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
