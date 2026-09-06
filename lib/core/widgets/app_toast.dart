import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Toast notification.
///
/// Use for success, error, warning, and info messages.
/// Auto-dismiss after duration.
enum AppToastType { success, error, warning, info }

void showAppToast(
  BuildContext context, {
  required String message,
  AppToastType type = AppToastType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  final icon = switch (type) {
    AppToastType.success => Icons.check_circle_outline,
    AppToastType.error => Icons.error_outline,
    AppToastType.warning => Icons.warning_amber_outlined,
    AppToastType.info => Icons.info_outline,
  };

  final color = switch (type) {
    AppToastType.success => AppColors.success,
    AppToastType.error => AppColors.error,
    AppToastType.warning => AppColors.warning,
    AppToastType.info => AppColors.info,
  };

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          AppSpacing.gapHorizontalSM,
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.radiusSM),
    ),
  );
}
