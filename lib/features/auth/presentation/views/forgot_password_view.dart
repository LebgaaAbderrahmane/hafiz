import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/auth_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Forgot password screen.
///
/// Simple email input + reset link.
class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleReset() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(authNotifierProvider.notifier).resetPassword(
          email: _emailController.text.trim(),
        );

    setState(() {
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _emailSent ? _buildSuccessView() : _buildFormView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.lock_reset_outlined,
            size: 48,
            color: AppColors.primary,
          ),
          AppSpacing.gapLG,
          Text(
            'نسيت كلمة المرور؟',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapSM,
          Text(
            'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapXXXL,

          AppTextField(
            label: 'البريد الإلكتروني',
            hint: 'email@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.email_outlined),
            onFieldSubmitted: (_) => _handleReset(),
          ),
          AppSpacing.gapXL,

          AppButton(
            onPressed: _handleReset,
            label: 'إرسال رابط إعادة التعيين',
            isExpanded: true,
            size: AppButtonSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.successSurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size: 40,
            color: AppColors.success,
          ),
        ),
        AppSpacing.gapLG,
        Text(
          'تم الإرسال',
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapSM,
        Text(
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى ${_emailController.text}',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapXXXL,
        AppButton(
          onPressed: () => context.pop(),
          label: 'العودة إلى تسجيل الدخول',
          isExpanded: true,
          variant: AppButtonVariant.outlined,
        ),
      ],
    );
  }
}
