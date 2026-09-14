import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/classes/domain/repositories/branch_provider.dart';
import 'package:hafiz/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:hafiz/features/settings/domain/entities/organization.dart';
import 'package:hafiz/features/settings/domain/entities/organization_user.dart';
import 'package:hafiz/features/settings/domain/repositories/settings_repository.dart';

/// Settings repository provider.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

/// Organization provider.
final organizationProvider =
    FutureProvider.autoDispose<Organization?>((ref) async {
  final orgId = ref.watch(activeOrganizationIdProvider);
  if (orgId == null) return null;

  final result =
      await ref.read(settingsRepositoryProvider).getOrganization(orgId);
  return result.fold(
    (failure) => throw failure,
    (org) => org,
  );
});

/// Organization users provider.
final organizationUsersProvider = AsyncNotifierProvider.autoDispose<
    OrganizationUsersNotifier,
    List<OrganizationUser>>(OrganizationUsersNotifier.new);

/// Organization users notifier.
class OrganizationUsersNotifier
    extends AutoDisposeAsyncNotifier<List<OrganizationUser>> {
  @override
  Future<List<OrganizationUser>> build() async {
    final orgId = ref.watch(activeOrganizationIdProvider);
    if (orgId == null) return [];

    final result =
        await ref.read(settingsRepositoryProvider).getOrganizationUsers(orgId);
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
