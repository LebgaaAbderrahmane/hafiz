import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Standard text input field.
///
/// Uses Directional padding for RTL support.
/// Always provide a label (use hintText as placeholder, not as label).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.autofocus = false,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final Value<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.label),
          AppSpacing.gapXS,
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          autofocus: autofocus,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixIconTap,
                    child: suffixIcon,
                  )
                : null,
            contentPadding: contentPadding,
          ),
        ),
      ],
    );
  }
}

/// Search bar with icon.
///
/// Used in list views for filtering.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
        suffixIcon: controller?.text.isNotEmpty == true
            ? GestureDetector(
                onTap: () {
                  controller?.clear();
                  onClear?.call();
                },
                child: const Icon(Icons.close, color: AppColors.textTertiary),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
