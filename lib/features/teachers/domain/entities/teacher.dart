import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher.freezed.dart';
part 'teacher.g.dart';

/// Teacher entity.
///
/// Maps to the teachers table in Supabase.
@freezed
abstract class Teacher with _$Teacher {
  factory Teacher({
    required String id,
    required String organizationId,
    required String branchId,
    required String userId,
    String? employeeId,
    required String fullName,
    String? preferredName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? avatarUrl,
    String? nationality,
    String? phone,
    String? email,
    String? specialization,
    @Default([]) List<String> qualifications,
    @Default([]) List<String> certifications,
    @Default([]) List<String> languagesSpoken,
    @Default(TeacherStatus.active) TeacherStatus status,
    DateTime? hireDate,
    DateTime? terminationDate,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Teacher;

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);
}

/// Teacher status in the lifecycle.
enum TeacherStatus {
  active,
  onLeave,
  inactive,
  terminated,
}

/// Gender enum (same as student).
enum Gender {
  male,
  female,
}

/// Extension for display names.
extension TeacherStatusExtension on TeacherStatus {
  String get displayName {
    return switch (this) {
      TeacherStatus.active => 'Active',
      TeacherStatus.onLeave => 'On Leave',
      TeacherStatus.inactive => 'Inactive',
      TeacherStatus.terminated => 'Terminated',
    };
  }

  String get displayNameAr {
    return switch (this) {
      TeacherStatus.active => 'نشط',
      TeacherStatus.onLeave => 'في إجازة',
      TeacherStatus.inactive => 'غير نشط',
      TeacherStatus.terminated => 'منتهي',
    };
  }
}

extension GenderExtension on Gender {
  String get displayName {
    return switch (this) {
      Gender.male => 'Male',
      Gender.female => 'Female',
    };
  }

  String get displayNameAr {
    return switch (this) {
      Gender.male => 'ذكر',
      Gender.female => 'أنثى',
    };
  }
}
