import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Loading overlay or inline indicator.
///
/// Use optimistic UI for teacher actions where safe.
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.size = AppLoadingSize.medium,
    this.message,
  });

  final AppLoadingSize size;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final indicatorSize = switch (size) {
      AppLoadingSize.small => 16.0,
      AppLoadingSize.medium => 24.0,
      AppLoadingSize.large => 40.0,
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          if (message != null) ...[
            AppSpacing.gapMD,
            Text(
              message!,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-screen loading overlay.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.8),
      child: AppLoading(size: AppLoadingSize.large, message: message),
    );
  }
}

enum AppLoadingSize { small, medium, large }
