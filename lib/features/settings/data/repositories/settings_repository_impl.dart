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
