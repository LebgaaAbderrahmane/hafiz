import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Empty state component.
///
/// Per design spec: "Every module needs useful empty states."
/// "Avoid blank screens."
/// Always provide a primary action and optional secondary action.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final String title;
  final String? description;
  final IconData icon;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.gapLG,
            Text(
              title,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              AppSpacing.gapSM,
              Text(
                description!,
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            if (primaryActionLabel != null) ...[
              AppSpacing.gapXL,
              AppButton(
                onPressed: onPrimaryAction,
                label: primaryActionLabel!,
                icon: Icons.add,
              ),
            ],
            if (secondaryActionLabel != null) ...[
              AppSpacing.gapSM,
              AppButton(
                onPressed: onSecondaryAction,
                label: secondaryActionLabel!,
                variant: AppButtonVariant.text,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
