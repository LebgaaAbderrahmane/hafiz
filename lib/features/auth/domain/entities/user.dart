import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Application user entity.
///
/// Maps to Supabase auth.users + public.users table.
@freezed
abstract class AppUser with _$AppUser {
  factory AppUser({
    required String id,
    required String email,
    String? phone,
    required String fullName,
    String? preferredName,
    String? avatarUrl,
    @Default('ar') String language,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

/// User role within an organization.
@freezed
abstract class UserRole with _$UserRole {
  factory UserRole({
    required String id,
    required String userId,
    required String organizationId,
    String? branchId,
    required Role role,
    required DateTime createdAt,
  }) = _UserRole;

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);
}

/// System roles.
enum Role {
  owner,
  superAdmin,
  branchManager,
  supervisor,
  teacher,
  assistant,
  reception,
  finance,
  parent,
  student,
}

/// Extension for display names.
extension RoleExtension on Role {
  String get displayName {
    return switch (this) {
      Role.owner => 'Owner',
      Role.superAdmin => 'Super Admin',
      Role.branchManager => 'Branch Manager',
      Role.supervisor => 'Supervisor',
      Role.teacher => 'Teacher',
      Role.assistant => 'Assistant',
      Role.reception => 'Reception',
      Role.finance => 'Finance',
      Role.parent => 'Parent',
      Role.student => 'Student',
    };
  }

  String get displayNameAr {
    return switch (this) {
      Role.owner => 'المالك',
      Role.superAdmin => 'مدير عام',
      Role.branchManager => 'مدير الفرع',
      Role.supervisor => 'المشرف',
      Role.teacher => 'المعلم',
      Role.assistant => 'المساعد',
      Role.reception => 'الاستقبال',
      Role.finance => 'المالية',
      Role.parent => 'ولي الأمر',
      Role.student => 'الطالب',
    };
  }
}
