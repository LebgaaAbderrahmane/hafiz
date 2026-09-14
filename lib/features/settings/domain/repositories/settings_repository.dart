import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/settings/domain/entities/organization.dart';
import 'package:hafiz/features/settings/domain/entities/organization_user.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Organization>> getOrganization(String id);
  Future<Either<Failure, Organization>> updateOrganization(
    String id, {
    String? name,
    String? address,
    String? phone,
    String? email,
  });

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
