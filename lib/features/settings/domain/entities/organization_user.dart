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
