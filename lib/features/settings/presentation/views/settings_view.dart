import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/drawer_icon_button.dart';
import '../../../auth/domain/entities/user.dart' show Role;
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/repositories/settings_provider.dart';

/// Settings view.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final activeRole = ref.watch(activeRoleProvider);
    final orgAsync = ref.watch(organizationProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const DrawerIconButton(),
        title: Text(context.l.settings),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.m),
        children: [
          _buildProfileSection(context, ref, currentUser),
          Gap.xl,

          _buildSection(context, context.l.settingsGeneral, [
            _buildSettingsTile(
              context,
              icon: Icons.language,
              title: context.l.settingsLanguage,
              subtitle: context.l.settingsLanguageArabic,
              onTap: () => _showLanguageDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.dark_mode,
              title: context.l.settingsTheme,
              subtitle: context.l.settingsThemeLight,
              onTap: () => _showThemeDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications,
              title: context.l.notifications,
              onTap: () => context.push('/notifications'),
            ),
          ]),
          Gap.xl,

          if (activeRole == Role.owner || activeRole == Role.superAdmin) ...[
            _buildSection(context, context.l.settingsOrganization, [
              _buildOrgInfoTile(context, ref, orgAsync),
              _buildSettingsTile(
                context,
                icon: Icons.location_on,
                title: context.l.settingsBranches,
                onTap: () => context.push('/settings/branches'),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.people,
                title: context.l.settingsUsers,
                onTap: () => context.push('/settings/users'),
              ),
            ]),
            Gap.xl,
          ],

          _buildSection(context, context.l.settingsData, [
            _buildSettingsTile(
              context,
              icon: Icons.backup,
              title: context.l.settingsBackup,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l.settingsBackupComingSoon)),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.download,
              title: context.l.settingsExportData,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l.settingsExportDataComingSoon)),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.upload,
              title: context.l.settingsImportData,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l.settingsImportDataComingSoon)),
                );
              },
            ),
          ]),
          Gap.xl,

          _buildSection(context, context.l.settingsAbout, [
            _buildSettingsTile(
              context,
              icon: Icons.info,
              title: context.l.settingsAboutApp,
              subtitle: context.l.settingsVersion,
              onTap: () => _showAboutDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.description,
              title: context.l.settingsTerms,
              onTap: () => _showTermsDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip,
              title: context.l.settingsPrivacy,
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
                context.l.logout,
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

  Widget _buildProfileSection(
      BuildContext context, WidgetRef ref, dynamic user) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                (user?.fullName ?? context.l.settingsUser)[0],
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
                    user?.fullName ?? context.l.settingsUser,
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

  Widget _buildOrgInfoTile(
      BuildContext context, WidgetRef ref, AsyncValue<dynamic> orgAsync) {
    return orgAsync.when(
      loading: () => ListTile(
        leading: const Icon(Icons.business, color: AppColors.primary),
        title: Text(context.l.settingsOrgInfo),
        subtitle: Text(context.l.settingsOrgLoading),
        trailing: const CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (e, _) => ListTile(
        leading: const Icon(Icons.business, color: AppColors.primary),
        title: Text(context.l.settingsOrgInfo),
        subtitle: Text(context.l.settingsOrgError),
        trailing: const Icon(Icons.chevron_left),
        onTap: () => _showOrgInfoDialog(context, null),
      ),
      data: (org) => ListTile(
        leading: const Icon(Icons.business, color: AppColors.primary),
        title: Text(org?.name ?? context.l.settingsOrgInfo),
        subtitle: org != null
            ? Text(org.address ?? org.email ?? '', maxLines: 1)
            : null,
        trailing: const Icon(Icons.chevron_left),
        onTap: () => _showOrgInfoDialog(context, org),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
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
        title: Text(context.l.settingsChangeLanguage),
        content: RadioGroup<String>(
          groupValue: 'ar',
          onChanged: (_) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l.settingsLanguageChanged)),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(context.l.settingsLanguageArabic),
                value: 'ar',
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
              ),
              RadioListTile<String>(
                title: const Text('Français'),
                value: 'fr',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l.settingsChangeTheme),
        content: RadioGroup<String>(
          groupValue: 'light',
          onChanged: (_) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l.settingsThemeChanged)),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(context.l.settingsThemeLight),
                value: 'light',
              ),
              RadioListTile<String>(
                title: Text(context.l.settingsThemeDark),
                value: 'dark',
              ),
              RadioListTile<String>(
                title: Text(context.l.settingsThemeAutomatic),
                value: 'system',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrgInfoDialog(BuildContext context, dynamic org) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l.settingsOrgInfo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${context.l.settingsOrgName}: ${org?.name ?? context.l.settingsNotDetermined}'),
            Gap.s,
            Text('${context.l.settingsOrgAddress}: ${org?.address ?? context.l.settingsNotDetermined}'),
            Gap.s,
            Text('${context.l.settingsOrgPhone}: ${org?.phone ?? context.l.settingsNotDetermined}'),
            Gap.s,
            Text('${context.l.settingsOrgEmail}: ${org?.email ?? context.l.settingsNotDetermined}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l.settingsClose),
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
      applicationIcon:
          const Icon(Icons.book, size: 48, color: AppColors.primary),
      children: [
        Text(context.l.settingsAppDescription),
        Gap.s,
        Text(context.l.settingsAppFeatures),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l.settingsTerms),
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
            child: Text(context.l.settingsClose),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l.settingsPrivacy),
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
            child: Text(context.l.settingsClose),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context, WidgetRef ref, dynamic user) {
    final nameController = TextEditingController(text: user?.fullName ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l.settingsEditProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.l.fullName,
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: context.l.phone,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l.cancel),
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
                    SnackBar(content: Text(context.l.settingsProfileUpdated)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${context.l.error}: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
              child: Text(context.l.save),
          ),
        ],
      ),
    );
  }
}
