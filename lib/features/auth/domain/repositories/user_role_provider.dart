import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';

/// Fetches all roles for the current authenticated user.
final userRolesProvider = FutureProvider<List<UserRole>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final repo = ref.watch(authRepositoryProvider);
  return repo.getUserRolesForUser(userId: user.id);
});

/// The active organization ID for the current user.
///
/// Returns the first organization the user belongs to.
/// In the future, this could support multi-org switching.
final activeOrganizationIdProvider = Provider<String?>((ref) {
  final roles = ref.watch(userRolesProvider);
  return roles.valueOrNull?.isNotEmpty == true
      ? roles.valueOrNull!.first.organizationId
      : null;
});

/// The active branch ID for the current user.
///
/// Returns the first branch the user belongs to.
/// Falls back to null if the user has no branch assignment.
final activeBranchIdProvider = Provider<String?>((ref) {
  final roles = ref.watch(userRolesProvider);
  return roles.valueOrNull?.isNotEmpty == true
      ? roles.valueOrNull!.first.branchId
      : null;
});

/// The user's active role in the current organization.
final activeRoleProvider = Provider<Role?>((ref) {
  final roles = ref.watch(userRolesProvider);
  return roles.valueOrNull?.isNotEmpty == true
      ? roles.valueOrNull!.first.role
      : null;
});
