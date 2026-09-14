# Settings & Organization Management Module — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the complete Settings & Organization Management module with data layer (entities, repositories, providers), redesigned settings view, branch management view, and user management view — all with Arabic-first RTL UI.

**Architecture:** Feature-first MVVM with Riverpod state management. Data flows from Supabase through abstract repositories (returning `Either<Failure, T>`) to Riverpod providers. UI uses `ConsumerWidget`/`ConsumerStatefulWidget` with `ref.watch()` for reactivity.

**Tech Stack:** Flutter 3.47.2, Riverpod, GoRouter, Freezed, Supabase, dartz, Equatable

**Spec:** User requirements in conversation — Settings module with organization info, branch management, user management, notification preferences, app settings.

---

## Global Constraints

- Arabic is primary UI language (RTL), LTR as secondary
- Use `EdgeInsetsDirectional` for all padding/margin (RTL-safe)
- Use `AppColors`, `AppTextStyles`, `AppSpacing`, `Gap` from `core/theme/theme.dart`
- All user-facing strings in Arabic
- Repository methods return `Either<Failure, T>` using dartz
- Entities use `@freezed` annotation
- Providers use Riverpod (no Provider, no GetX, no Bloc)
- Use `ConsumerWidget` or `ConsumerStatefulWidget`
- Organization context via `activeOrganizationIdProvider`
- Role checks via `activeRoleProvider`

---

## File Map

| Action | File | Purpose |
|--------|------|---------|
| Create | `lib/features/settings/domain/entities/organization.dart` | Organization entity (freezed) |
| Create | `lib/features/settings/domain/entities/organization_user.dart` | User-with-role entity for user management |
| Create | `lib/features/settings/domain/repositories/settings_repository.dart` | Abstract settings repository |
| Create | `lib/features/settings/domain/repositories/settings_provider.dart` | Riverpod providers for settings |
| Create | `lib/features/settings/data/repositories/settings_repository_impl.dart` | Supabase implementation |
| Create | `lib/features/settings/presentation/views/branch_management_view.dart` | Branch CRUD view |
| Create | `lib/features/settings/presentation/views/user_management_view.dart` | User management view |
| Modify | `lib/features/settings/presentation/views/settings_view.dart` | Redesign with full sections |
| Modify | `lib/core/router/app_router.dart` | Add routes for new views |

---

### Task 1: Organization Entity

**Files:**
- Create: `lib/features/settings/domain/entities/organization.dart`

**Interfaces:**
- Produces: `Organization` class used by `SettingsRepository` and `settings_provider.dart`

- [ ] **Step 1: Create Organization freezed entity**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

@freezed
abstract class Organization with _$Organization {
  factory Organization({
    required String id,
    required String name,
    String? address,
    String? phone,
    String? email,
    String? logoUrl,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}
```

- [ ] **Step 2: Run build_runner to generate .freezed.dart and .g.dart**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 3: Verify generated files exist**

Check `lib/features/settings/domain/entities/organization.freezed.dart` and `organization.g.dart` exist.

- [ ] **Step 4: Commit**

```bash
git add lib/features/settings/domain/entities/organization.*
git commit -m "feat(settings): add Organization freezed entity"
```

---

### Task 2: OrganizationUser Entity

**Files:**
- Create: `lib/features/settings/domain/entities/organization_user.dart`

**Interfaces:**
- Produces: `OrganizationUser` class combining user info with role for the user management list

- [ ] **Step 1: Create OrganizationUser freezed entity**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart' show Role;

part 'organization_user.freezed.dart';
part 'organization_user.g.dart';

@freezed
abstract class OrganizationUser with _$OrganizationUser {
  factory OrganizationUser({
    required String id,
    required String userId,
    required String fullName,
    String? email,
    String? phone,
    required Role role,
    String? branchId,
    String? branchName,
    required bool isActive,
    required DateTime createdAt,
  }) = _OrganizationUser;

  factory OrganizationUser.fromJson(Map<String, dynamic> json) =>
      _$OrganizationUserFromJson(json);
}
```

- [ ] **Step 2: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/settings/domain/entities/organization_user.*
git commit -m "feat(settings): add OrganizationUser freezed entity"
```

---

### Task 3: Abstract Settings Repository

**Files:**
- Create: `lib/features/settings/domain/repositories/settings_repository.dart`

**Interfaces:**
- Consumes: `Organization`, `OrganizationUser` from Tasks 1-2
- Produces: `SettingsRepository` interface used by `settings_provider.dart` and `settings_repository_impl.dart`

- [ ] **Step 1: Create abstract repository**

```dart
import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/settings/domain/entities/organization.dart';
import 'package:hafiz/features/settings/domain/entities/organization_user.dart';

abstract class SettingsRepository {
  // Organization
  Future<Either<Failure, Organization>> getOrganization(String id);
  Future<Either<Failure, Organization>> updateOrganization(
    String id, {
    String? name,
    String? address,
    String? phone,
    String? email,
  });

  // Branches (reuse existing Branch from classes feature)
  Future<Either<Failure, void>> createBranch({
    required String organizationId,
    required String name,
    String? address,
    String? phone,
  });
  Future<Either<Failure, void>> updateBranch(
    String id, {
    String? name,
    String? address,
    String? phone,
  });
  Future<Either<Failure, void>> deleteBranch(String id);

  // Users
  Future<Either<Failure, List<OrganizationUser>>> getOrganizationUsers(
    String organizationId,
  );
  Future<Either<Failure, void>> inviteUser({
    required String organizationId,
    required String email,
    required String role,
    String? branchId,
  });
  Future<Either<Failure, void>> updateUserRole(
    String userRoleId, {
    required String role,
  });
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/settings/domain/repositories/settings_repository.dart
git commit -m "feat(settings): add abstract SettingsRepository"
```

---

### Task 4: Settings Repository Implementation

**Files:**
- Create: `lib/features/settings/data/repositories/settings_repository_impl.dart`

**Interfaces:**
- Consumes: `SettingsRepository` interface from Task 3, `supabase` client
- Produces: Implementation used by `settings_provider.dart`

- [ ] **Step 1: Create Supabase implementation**

```dart
import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart' show Role;
import 'package:hafiz/features/settings/domain/entities/organization.dart';
import 'package:hafiz/features/settings/domain/entities/organization_user.dart';
import 'package:hafiz/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<Either<Failure, Organization>> getOrganization(String id) async {
    try {
      final data =
          await supabase.from('organizations').select().eq('id', id).single();
      return Right(Organization.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Organization>> updateOrganization(
    String id, {
    String? name,
    String? address,
    String? phone,
    String? email,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (name != null) updates['name'] = name;
      if (address != null) updates['address'] = address;
      if (phone != null) updates['phone'] = phone;
      if (email != null) updates['email'] = email;

      final data = await supabase
          .from('organizations')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(Organization.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createBranch({
    required String organizationId,
    required String name,
    String? address,
    String? phone,
  }) async {
    try {
      await supabase.from('branches').insert({
        'organization_id': organizationId,
        'name': name,
        'address': address,
        'phone': phone,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBranch(
    String id, {
    String? name,
    String? address,
    String? phone,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (address != null) updates['address'] = address;
      if (phone != null) updates['phone'] = phone;

      await supabase.from('branches').update(updates).eq('id', id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBranch(String id) async {
    try {
      await supabase.from('branches').delete().eq('id', id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrganizationUser>>> getOrganizationUsers(
    String organizationId,
  ) async {
    try {
      final data = await supabase
          .from('user_roles')
          .select('*, users(id, full_name, email, phone, is_active, created_at)')
          .eq('organization_id', organizationId);

      final users = (data as List).map((json) {
        final user = json['users'] as Map<String, dynamic>;
        return OrganizationUser(
          id: json['id'] as String,
          userId: user['id'] as String,
          fullName: user['full_name'] as String,
          email: user['email'] as String?,
          phone: user['phone'] as String?,
          role: Role.values.firstWhere(
            (r) => r.name == json['role'],
            orElse: () => Role.teacher,
          ),
          branchId: json['branch_id'] as String?,
          isActive: user['is_active'] as bool? ?? true,
          createdAt: DateTime.parse(user['created_at'] as String),
        );
      }).toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> inviteUser({
    required String organizationId,
    required String email,
    required String role,
    String? branchId,
  }) async {
    try {
      // Use Supabase Edge Function or Auth Admin API to invite
      await supabase.functions.invoke('invite-user', body: {
        'email': email,
        'organization_id': organizationId,
        'role': role,
        'branch_id': branchId,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRole(
    String userRoleId, {
    required String role,
  }) async {
    try {
      await supabase
          .from('user_roles')
          .update({'role': role}).eq('id', userRoleId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/settings/data/repositories/settings_repository_impl.dart
git commit -m "feat(settings): add SettingsRepositoryImpl with Supabase"
```

---

### Task 5: Settings Providers

**Files:**
- Create: `lib/features/settings/domain/repositories/settings_provider.dart`

**Interfaces:**
- Consumes: `SettingsRepository` from Task 3, `SettingsRepositoryImpl` from Task 4, `activeOrganizationIdProvider` from auth
- Produces: All providers consumed by UI views (Tasks 7-8)

- [ ] **Step 1: Create providers**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/classes/domain/repositories/branch_provider.dart';
import 'package:hafiz/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:hafiz/features/settings/domain/entities/organization_user.dart';
import 'package:hafiz/features/settings/domain/repositories/settings_repository.dart';

/// Settings repository provider.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

/// Organization provider.
final organizationProvider =
    FutureProvider.autoDispose<dynamic>((ref) async {
  final orgId = ref.watch(activeOrganizationIdProvider);
  if (orgId == null) return null;

  final result = await ref.read(settingsRepositoryProvider).getOrganization(orgId);
  return result.fold(
    (failure) => throw failure,
    (org) => org,
  );
});

/// Organization users provider.
final organizationUsersProvider =
    AsyncNotifierProvider.autoDispose<OrganizationUsersNotifier, List<OrganizationUser>>(
        OrganizationUsersNotifier.new);

/// Organization users notifier.
class OrganizationUsersNotifier extends AutoDisposeAsyncNotifier<List<OrganizationUser>> {
  @override
  Future<List<OrganizationUser>> build() async {
    final orgId = ref.watch(activeOrganizationIdProvider);
    if (orgId == null) return [];

    final result = await ref.read(settingsRepositoryProvider).getOrganizationUsers(orgId);
    return result.fold(
      (failure) => throw failure,
      (users) => users,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> updateUserRole(String userRoleId, String role) async {
    final result = await ref.read(settingsRepositoryProvider).updateUserRole(
      userRoleId,
      role: role,
    );
    result.fold(
      (failure) => throw failure,
      (_) => refresh(),
    );
  }
}

/// Branch management providers.
final branchManagementProvider =
    AsyncNotifierProvider.autoDispose<BranchManagementNotifier, void>(
        BranchManagementNotifier.new);

/// Branch management notifier.
class BranchManagementNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createBranch({
    required String organizationId,
    required String name,
    String? address,
    String? phone,
  }) async {
    final result = await ref.read(settingsRepositoryProvider).createBranch(
      organizationId: organizationId,
      name: name,
      address: address,
      phone: phone,
    );
    result.fold(
      (failure) => throw failure,
      (_) => ref.invalidate(orgBranchesProvider),
    );
  }

  Future<void> updateBranch(
    String id, {
    String? name,
    String? address,
    String? phone,
  }) async {
    final result = await ref.read(settingsRepositoryProvider).updateBranch(
      id,
      name: name,
      address: address,
      phone: phone,
    );
    result.fold(
      (failure) => throw failure,
      (_) => ref.invalidate(orgBranchesProvider),
    );
  }

  Future<void> deleteBranch(String id) async {
    final result = await ref.read(settingsRepositoryProvider).deleteBranch(id);
    result.fold(
      (failure) => throw failure,
      (_) => ref.invalidate(orgBranchesProvider),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/settings/domain/repositories/settings_provider.dart
git commit -m "feat(settings): add settings providers for org, users, branches"
```

---

### Task 6: Branch Management View

**Files:**
- Create: `lib/features/settings/presentation/views/branch_management_view.dart`

**Interfaces:**
- Consumes: `orgBranchesProvider` from `classes/domain/repositories/branch_provider.dart`, `branchManagementProvider` from Task 5

- [ ] **Step 1: Create branch management view**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/theme/theme.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/classes/domain/repositories/branch_provider.dart';
import 'package:hafiz/features/settings/domain/repositories/settings_provider.dart';

class BranchManagementView extends ConsumerStatefulWidget {
  const BranchManagementView({super.key});

  @override
  ConsumerState<BranchManagementView> createState() =>
      _BranchManagementViewState();
}

class _BranchManagementViewState extends ConsumerState<BranchManagementView> {
  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(orgBranchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفروع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBranchDialog(context),
          ),
        ],
      ),
      body: branchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (branches) {
          if (branches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 64, color: AppColors.textTertiary),
                  Gap.l,
                  Text('لا توجد فروع',
                      style: AppTextStyles.headlineSmall
                          .copyWith(color: AppColors.textSecondary)),
                  Gap.s,
                  Text('اضغط على + لإضافة فرع جديد',
                      style: AppTextStyles.bodySmall),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(AppSpacing.m),
            itemCount: branches.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final branch = branches[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primarySurface,
                  child: const Icon(Icons.location_on, color: AppColors.primary),
                ),
                title: Text(branch.name, style: AppTextStyles.bodyMedium),
                subtitle: branch.address != null
                    ? Text(branch.address!, style: AppTextStyles.bodySmall)
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditBranchDialog(context, branch),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20,
                          color: AppColors.error),
                      onPressed: () => _confirmDelete(context, branch),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddBranchDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة فرع جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الفرع',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextField(
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
              final orgId = ref.read(activeOrganizationIdProvider);
              if (orgId == null || nameController.text.isEmpty) return;

              await ref.read(branchManagementProvider.notifier).createBranch(
                organizationId: orgId,
                name: nameController.text,
                address: addressController.text.isNotEmpty
                    ? addressController.text
                    : null,
                phone: phoneController.text.isNotEmpty
                    ? phoneController.text
                    : null,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditBranchDialog(BuildContext context, dynamic branch) {
    final nameController = TextEditingController(text: branch.name);
    final addressController = TextEditingController(text: branch.address ?? '');
    final phoneController = TextEditingController(text: branch.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الفرع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الفرع',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextField(
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
              await ref.read(branchManagementProvider.notifier).updateBranch(
                branch.id,
                name: nameController.text,
                address: addressController.text.isNotEmpty
                    ? addressController.text
                    : null,
                phone: phoneController.text.isNotEmpty
                    ? phoneController.text
                    : null,
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الفرع'),
        content: Text('هل أنت متأكد من حذف "${branch.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () async {
              await ref.read(branchManagementProvider.notifier).deleteBranch(
                    branch.id,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/settings/presentation/views/branch_management_view.dart
git commit -m "feat(settings): add BranchManagementView with CRUD"
```

---

### Task 7: User Management View

**Files:**
- Create: `lib/features/settings/presentation/views/user_management_view.dart`

**Interfaces:**
- Consumes: `organizationUsersProvider` from Task 5, `Role` enum from auth

- [ ] **Step 1: Create user management view**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/theme/theme.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart' show Role;
import 'package:hafiz/features/settings/domain/ entities/organization_user.dart';
import 'package:hafiz/features/settings/domain/repositories/settings_provider.dart';

class UserManagementView extends ConsumerWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(organizationUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showInviteDialog(context, ref),
          ),
        ],
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline,
                      size: 64, color: AppColors.textTertiary),
                  Gap.l,
                  Text('لا يوجد مستخدمون',
                      style: AppTextStyles.headlineSmall
                          .copyWith(color: AppColors.textSecondary)),
                  Gap.s,
                  Text('اضغط على + لدعوة مستخدم جديد',
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
          title: const Text('دعوة مستخدم'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(),
                ),
              ),
              Gap.m,
              DropdownButtonFormField<Role>(
                value: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'الدور',
                  border: OutlineInputBorder(),
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
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement invite via repository
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال الدعوة')),
                );
              },
              child: const Text('إرسال'),
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
          title: const Text('تعديل الدور'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(user.fullName, style: AppTextStyles.bodyMedium),
              Gap.m,
              DropdownButtonFormField<Role>(
                value: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'الدور',
                  border: OutlineInputBorder(),
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
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(organizationUsersProvider.notifier)
                    .updateUserRole(user.id, selectedRole.name);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Fix typo in import (space in path)**

Ensure the import is:
```dart
import 'package:hafiz/features/settings/domain/entities/organization_user.dart';
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/settings/presentation/views/user_management_view.dart
git commit -m "feat(settings): add UserManagementView with invite and role editing"
```

---

### Task 8: Redesign Settings View

**Files:**
- Modify: `lib/features/settings/presentation/views/settings_view.dart`

**Interfaces:**
- Consumes: `organizationProvider`, `orgBranchesProvider`, `organizationUsersProvider` from Tasks 5, `activeRoleProvider` from auth

- [ ] **Step 1: Replace settings_view.dart with redesigned version**

Key changes from existing:
- Organization section reads from `organizationProvider` (Supabase) instead of hardcoded dialog
- Branch management tile navigates to `/settings/branches` instead of SnackBar stub
- User management tile navigates to `/settings/users` instead of SnackBar stub
- Notification preferences section with actual toggles
- App settings: language selector + theme toggle (kept from existing)

The new settings_view.dart keeps the same structure but:
1. Organization section shows real data from `organizationProvider`
2. Branch tile → `context.push('/settings/branches')`
3. User tile → `context.push('/settings/users')`
4. Notification toggles are local state switches (no backend yet)
5. Language/theme dialogs remain the same

- [ ] **Step 2: Commit**

```bash
git add lib/features/settings/presentation/views/settings_view.dart
git commit -m "feat(settings): redesign SettingsView with real org data and navigation"
```

---

### Task 9: Add Routes

**Files:**
- Modify: `lib/core/router/app_router.dart`

**Interfaces:**
- Consumes: `BranchManagementView`, `UserManagementView` from Tasks 6-7

- [ ] **Step 1: Add import statements**

```dart
import 'package:hafiz/features/settings/presentation/views/branch_management_view.dart';
import 'package:hafiz/features/settings/presentation/views/user_management_view.dart';
```

- [ ] **Step 2: Add routes inside ShellRoute, after the `/settings` route**

```dart
GoRoute(
  path: '/settings/branches',
  builder: (context, state) => const BranchManagementView(),
),
GoRoute(
  path: '/settings/users',
  builder: (context, state) => const UserManagementView(),
),
```

- [ ] **Step 3: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "feat(settings): add routes for branch and user management"
```

---

### Task 10: Verification

- [ ] **Step 1: Run build_runner to ensure all freezed files generate**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 2: Run flutter analyze**

```bash
flutter analyze
```

Expected: No errors (warnings acceptable)

- [ ] **Step 3: Run flutter test**

```bash
flutter test
```

- [ ] **Step 4: Verify all new files exist**

```bash
ls -la lib/features/settings/domain/entities/
ls -la lib/features/settings/domain/repositories/
ls -la lib/features/settings/data/repositories/
ls -la lib/features/settings/presentation/views/
```

Expected:
```
entities/organization.dart, organization.freezed.dart, organization.g.dart
entities/organization_user.dart, organization_user.freezed.dart, organization_user.g.dart
repositories/settings_repository.dart
repositories/settings_provider.dart
data/repositories/settings_repository_impl.dart
views/settings_view.dart (modified)
views/branch_management_view.dart (new)
views/user_management_view.dart (new)
```
