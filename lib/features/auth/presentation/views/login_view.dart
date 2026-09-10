import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/core/theme/theme.dart';
import 'package:hafiz/core/widgets/widgets.dart';

/// Login screen.
///
/// Minimal, focused design per design spec:
/// "No dashboard-style marketing content."
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(authNotifierProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AsyncValue<AppUser?>>(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        showAppToast(
          context,
          message: next.error.toString(),
          type: AppToastType.error,
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Logo / Title ──
                    Icon(
                      Icons.menu_book_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    AppSpacing.gapLG,
                    Text(
                      'حافظ',
                      style: AppTextStyles.arabicH1.copyWith(
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapXS,
                    Text(
                      'Hafiz',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapXS,
                    Text(
                      'Qur\'an School Management',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapXXXL,

                    // ── Email ──
                    AppTextField(
                      label: 'البريد الإلكتروني',
                      hint: 'email@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    AppSpacing.gapLG,

                    // ── Password ──
                    AppTextField(
                      label: 'كلمة المرور',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onSuffixIconTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onFieldSubmitted: (_) => _handleLogin(),
                    ),
                    AppSpacing.gapSM,

                    // ── Forgot Password ──
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: const Text('نسيت كلمة المرور؟'),
                      ),
                    ),
                    AppSpacing.gapXL,

                    // ── Login Button ──
                    AppButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      label: 'تسجيل الدخول',
                      isLoading: authState.isLoading,
                      isExpanded: true,
                      size: AppButtonSize.large,
                    ),
                    AppSpacing.gapXL,

                    // ── Divider ──
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: Text(
                            'أو',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    AppSpacing.gapXL,

                    // ── Sign Up Link ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to sign up
                          },
                          child: const Text('إنشاء حساب'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
