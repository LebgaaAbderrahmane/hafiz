import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Primary action button.
///
/// Use for the single dominant action on each screen.
/// Follows the design spec: "Every screen should have one dominant action."
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  final VoidCallback? onPressed;
  final String label;
  final AppButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    final button = switch (variant) {
      AppButtonVariant.primary => _buildPrimary(effectiveOnPressed),
      AppButtonVariant.secondary => _buildSecondary(effectiveOnPressed),
      AppButtonVariant.outlined => _buildOutlined(effectiveOnPressed),
      AppButtonVariant.text => _buildText(effectiveOnPressed),
      AppButtonVariant.danger => _buildDanger(effectiveOnPressed),
    };

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildPrimary(VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: _padding,
        minimumSize: _minimumSize,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildSecondary(VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textOnPrimary,
        padding: _padding,
        minimumSize: _minimumSize,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildOutlined(VoidCallback? onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: _padding,
        minimumSize: _minimumSize,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildText(VoidCallback? onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: _padding,
        minimumSize: _minimumSize,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildDanger(VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.textOnPrimary,
        padding: _padding,
        minimumSize: _minimumSize,
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary || variant == AppButtonVariant.danger
                ? AppColors.textOnPrimary
                : AppColors.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize),
          SizedBox(width: AppSpacing.sm),
          Text(label, style: _textStyle),
        ],
      );
    }

    return Text(label, style: _textStyle);
  }

  TextStyle get _textStyle {
    final baseStyle = switch (size) {
      AppButtonSize.small => AppTextStyles.buttonSmall,
      AppButtonSize.medium => AppTextStyles.buttonMedium,
      AppButtonSize.large => AppTextStyles.buttonLarge,
    };

    final color = switch (variant) {
      AppButtonVariant.primary || AppButtonVariant.danger => AppColors.textOnPrimary,
      AppButtonVariant.secondary => AppColors.textOnPrimary,
      AppButtonVariant.outlined || AppButtonVariant.text => AppColors.primary,
    };

    return baseStyle.copyWith(color: color);
  }

  EdgeInsets get _padding => switch (size) {
    AppButtonSize.small => const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    AppButtonSize.medium => const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.lg,
      ),
    AppButtonSize.large => const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxxl,
        vertical: AppSpacing.xl,
      ),
  };

  Size get _minimumSize => switch (size) {
    AppButtonSize.small => const Size(0, 32),
    AppButtonSize.medium => const Size(0, 44),
    AppButtonSize.large => const Size(0, 52),
  };

  double get _iconSize => switch (size) {
    AppButtonSize.small => 14,
    AppButtonSize.medium => 16,
    AppButtonSize.large => 18,
  };
}

enum AppButtonVariant { primary, secondary, outlined, text, danger }
