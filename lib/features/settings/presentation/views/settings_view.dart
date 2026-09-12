import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/entities/user.dart' show Role;
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';

/// Settings view.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final activeRole = ref.watch(activeRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.m),
        children: [
          _buildProfileSection(context, ref, currentUser),
          Gap.xl,

          _buildSection(context, 'عام', [
            _buildSettingsTile(
              context,
              icon: Icons.language,
              title: 'اللغة',
              subtitle: 'العربية',
              onTap: () => _showLanguageDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.dark_mode,
              title: 'المظهر',
              subtitle: 'فاتح',
              onTap: () => _showThemeDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications,
              title: 'الإشعارات',
              onTap: () => context.push('/notifications'),
            ),
          ]),
          Gap.xl,

          if (activeRole == Role.owner || activeRole == Role.superAdmin) ...[
            _buildSection(context, 'المؤسسة', [
              _buildSettingsTile(
                context,
                icon: Icons.business,
                title: 'معلومات المؤسسة',
                onTap: () => _showOrgInfoDialog(context),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.location_on,
                title: 'الفروع',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('إدارة الفروع قيد التطوير')),
                  );
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.people,
                title: 'المستخدمون',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('إدارة المستخدمين قيد التطوير')),
                  );
                },
              ),
            ]),
            Gap.xl,
          ],

          _buildSection(context, 'البيانات', [
            _buildSettingsTile(
              context,
              icon: Icons.backup,
              title: 'النسخ الاحتياطي',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('النسخ الاحتياطي قيد التطوير')),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.download,
              title: 'تصدير البيانات',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تصدير البيانات قيد التطوير')),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.upload,
              title: 'استيراد البيانات',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('استيراد البيانات قيد التطوير')),
                );
              },
            ),
          ]),
          Gap.xl,

          _buildSection(context, 'حول', [
            _buildSettingsTile(
              context,
              icon: Icons.info,
              title: 'عن التطبيق',
              subtitle: 'الإصدار 1.0.0',
              onTap: () => _showAboutDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.description,
              title: 'الشروط والأحكام',
              onTap: () => _showTermsDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip,
              title: 'سياسة الخصوصية',
              onTap: () => _showPrivacyDialog(context),
            ),
          ]),
          Gap.xl,

          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(
                'تسجيل الخروج',
                style: TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
          Gap.xl,
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, WidgetRef ref, dynamic user) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                (user?.fullName ?? 'م')[0],
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            Gap.m,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? 'مستخدم',
                    style: AppTextStyles.titleMedium,
                  ),
                  Gap.xs,
                  Text(
                    user?.email ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditProfileDialog(context, ref, user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s),
          child: Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        Gap.s,
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_left),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختيار اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('العربية'),
              value: 'ar',
              groupValue: 'ar',
              onChanged: (_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تغيير اللغة إلى العربية')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'ar',
              onChanged: (_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language changed to English')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'fr',
              groupValue: 'ar',
              onChanged: (_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Langue changée en Français')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختيار المظهر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('فاتح'),
              value: 'light',
              groupValue: 'light',
              onChanged: (_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('المظهر الفاتح')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('داكن'),
              value: 'dark',
              groupValue: 'light',
              onChanged: (_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الوضع الداكن قيد التطوير')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('تلقائي'),
              value: 'system',
              groupValue: 'light',
              onChanged: (_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يتم اتباع إعدادات النظام')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOrgInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('معلومات المؤسسة'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اسم المؤسسة: إدارة القرآن الكريم'),
            Gap.s,
            Text('العنوان: الرياض، المملكة العربية السعودية'),
            Gap.s,
            Text('الهاتف: 0500000000'),
            Gap.s,
            Text('البريد: info@hafiz.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Hafiz',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.book, size: 48, color: AppColors.primary),
      children: const [
        Text('تطبيق إدارة مدارس القرآن الكريم'),
        Gap.s,
        Text('إدارة الطلاب والمعلمين والحضور والحفظ والمراجعات'),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الشروط والأحكام'),
        content: const SingleChildScrollView(
          child: Text(
            'شروط الاستخدام\n\n'
            'باستخدامك لتطبيق Hafiz، أنت توافق على الشروط التالية:\n\n'
            '1. استخدام التطبيق لأغراض تعليمية فقط\n'
            '2. حماية بيانات المستخدمين وعدم مشاركتها\n'
            '3. عدم استخدام التطبيق لأي غرض غير قانوني\n'
            '4. الالتزام بسياسات الخصوصية\n\n'
            '© 2026 Hafiz. جميع الحقوق محفوظة.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Text(
            'سياسة الخصوصية\n\n'
            'نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.\n\n'
            'جمع البيانات:\n'
            '- نجمع فقط البيانات الضرورية لتشغيل التطبيق\n'
            '- بيانات التسجيل (الاسم، البريد الإلكتروني)\n'
            '- بيانات الطلاب والمعلمين لإدارة المدرسة\n\n'
            'استخدام البيانات:\n'
            '- لتقديم خدمات التعليم\n'
            '- لتحسين تجربة المستخدم\n'
            '- لا نشارك البيانات مع أطراف ثالثة\n\n'
            'حقوقك:\n'
            '- الاطلاع على بياناتك\n'
            '- تعديل أو حذف بياناتك\n'
            '- تصدير بياناتك\n\n'
            '© 2026 Hafiz. جميع الحقوق محفوظة.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, dynamic user) {
    final nameController = TextEditingController(text: user?.fullName ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الملف الشخصي'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم الكامل',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'الهاتف',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authRepositoryProvider).updateProfile(
                      fullName: nameController.text,
                      phone: phoneController.text.isNotEmpty
                          ? phoneController.text
                          : null,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.invalidate(currentUserProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تعديل الملف الشخصي')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
