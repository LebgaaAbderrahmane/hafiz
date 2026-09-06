import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Confirmation modal for destructive actions.
///
/// Per design spec: "Ask confirmation for deleting students,
/// deleting academic records, changing financial records,
/// changing permissions, irreversible actions."
///
/// Do NOT ask confirmation for harmless actions.
Future<bool> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDangerous = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message, style: AppTextStyles.body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous ? AppColors.error : AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Bottom sheet modal.
///
/// Use for action sheets, filters, and forms that don't
/// require a full page navigation.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: title != null ? 0.7 : 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppTextStyles.h3),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: child,
            ),
          ),
        ],
      ),
    ),
  );
}
