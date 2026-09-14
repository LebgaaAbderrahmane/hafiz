import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/localization/app_localizations.dart';
import 'package:hafiz/core/theme/theme.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart'
    show Role, RoleExtension;
import 'package:hafiz/features/settings/domain/entities/organization_user.dart';
import 'package:hafiz/features/settings/domain/repositories/settings_provider.dart';

class UserManagementView extends ConsumerWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(organizationUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.userManagementTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showInviteDialog(context, ref),
          ),
        ],
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${context.l.error}: $e')),
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline,
                      size: 64, color: AppColors.textTertiary),
                  Gap.l,
                  Text(context.l.userManagementEmpty,
                      style: AppTextStyles.headlineSmall
                          .copyWith(color: AppColors.textSecondary)),
                  Gap.s,
                  Text(context.l.userManagementAddHint,
                      style: AppTextStyles.bodySmall),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(AppSpacing.m),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildUserTile(context, ref, user);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserTile(
      BuildContext context, WidgetRef ref, OrganizationUser user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: user.isActive
            ? AppColors.primarySurface
            : AppColors.surfaceVariant,
        child: Text(
          user.fullName.isNotEmpty ? user.fullName[0] : '?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: user.isActive ? AppColors.primary : AppColors.textTertiary,
          ),
        ),
      ),
      title: Text(user.fullName, style: AppTextStyles.bodyMedium),
      subtitle: Text(
        user.email ?? user.phone ?? '',
        style: AppTextStyles.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRoleBadge(user.role),
          Gap.s,
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditRoleDialog(context, ref, user),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(Role role) {
    final color = switch (role) {
      Role.owner || Role.superAdmin => AppColors.primary,
      Role.branchManager || Role.supervisor => AppColors.secondary,
      Role.teacher || Role.assistant => AppColors.info,
      _ => AppColors.textTertiary,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.radiusPill,
      ),
      child: Text(
        role.displayNameAr,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }

  void _showInviteDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    Role selectedRole = Role.teacher;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l.userManagementInvite),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: context.l.email,
                  border: const OutlineInputBorder(),
                ),
              ),
              Gap.m,
              DropdownButtonFormField<Role>(
                initialValue: selectedRole,
                decoration: InputDecoration(
                  labelText: context.l.userManagementRole,
                  border: const OutlineInputBorder(),
                ),
                items: Role.values
                    .where((r) => r != Role.student && r != Role.parent)
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.displayNameAr),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedRole = value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l.userManagementInviteSent)),
                );
              },
              child: Text(context.l.userManagementSend),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditRoleDialog(
      BuildContext context, WidgetRef ref, OrganizationUser user) {
    Role selectedRole = user.role;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l.userManagementEditRole),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(user.fullName, style: AppTextStyles.bodyMedium),
              Gap.m,
              DropdownButtonFormField<Role>(
                initialValue: selectedRole,
                decoration: InputDecoration(
                  labelText: context.l.userManagementRole,
                  border: const OutlineInputBorder(),
                ),
                items: Role.values
                    .where((r) => r != Role.student && r != Role.parent)
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.displayNameAr),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedRole = value);
                  }
                },
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
                await ref
                    .read(organizationUsersProvider.notifier)
                    .updateUserRole(user.id, selectedRole.name);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(context.l.save),
            ),
          ],
        ),
      ),
    );
  }
}
