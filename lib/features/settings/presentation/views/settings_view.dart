import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/domain/repositories/auth_provider.dart';

/// Settings view.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.m),
        children: [
          // Profile section
          _buildProfileSection(context, currentUser),
          Gap.xl,

          // General settings
          _buildSection(context, 'عام', [
            _buildSettingsTile(
              context,
              icon: Icons.language,
              title: 'اللغة',
              subtitle: 'العربية',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.dark_mode,
              title: 'المظهر',
              subtitle: 'فاتح',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications,
              title: 'الإشعارات',
              onTap: () {},
            ),
          ]),
          Gap.xl,

          // Organization settings
          _buildSection(context, 'المؤسسة', [
            _buildSettingsTile(
              context,
              icon: Icons.business,
              title: 'معلومات المؤسسة',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.location_on,
              title: 'الفروع',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.people,
              title: 'المستخدمون',
              onTap: () {},
            ),
          ]),
          Gap.xl,

          // Data settings
          _buildSection(context, 'البيانات', [
            _buildSettingsTile(
              context,
              icon: Icons.backup,
              title: 'النسخ الاحتياطي',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.download,
              title: 'تصدير البيانات',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.upload,
              title: 'استيراد البيانات',
              onTap: () {},
            ),
          ]),
          Gap.xl,

          // About
          _buildSection(context, 'حول', [
            _buildSettingsTile(
              context,
              icon: Icons.info,
              title: 'عن التطبيق',
              subtitle: 'الإصدار 1.0.0',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.description,
              title: 'الشروط والأحكام',
              onTap: () {},
            ),
            _buildSettingsTile(
              context,
              icon: Icons.privacy_tip,
              title: 'سياسة الخصوصية',
              onTap: () {},
            ),
          ]),
          Gap.xl,

          // Logout
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

  Widget _buildProfileSection(BuildContext context, dynamic user) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                (user?.name ?? 'م')[0],
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
                    user?.name ?? 'مستخدم',
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
              onPressed: () {},
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
}
