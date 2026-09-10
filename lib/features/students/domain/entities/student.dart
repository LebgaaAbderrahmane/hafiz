import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

/// Student entity.
///
/// Maps to the students table in Supabase.
@freezed
abstract class Student with _$Student {
  factory Student({
    required String id,
    required String organizationId,
    required String branchId,
    String? studentId,
    required String fullName,
    String? preferredName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? avatarUrl,
    String? nationality,
    @Default('ar') String language,
    String? phone,
    String? email,
    @Default(StudentStatus.active) StudentStatus status,
    String? previousQuranEducation,
    String? currentQuranLevel,
    String? readingLevel,
    String? tajwidLevel,
    String? memorizationLevel,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}

/// Student status in the lifecycle.
enum StudentStatus {
  lead,
  applicant,
  active,
  suspended,
  graduated,
  withdrawn,
  archived,
}

/// Gender enum.
enum Gender {
  male,
  female,
}

/// Extension for display names.
extension StudentStatusExtension on StudentStatus {
  String get displayName {
    return switch (this) {
      StudentStatus.lead => 'Lead',
      StudentStatus.applicant => 'Applicant',
      StudentStatus.active => 'Active',
      StudentStatus.suspended => 'Suspended',
      StudentStatus.graduated => 'Graduated',
      StudentStatus.withdrawn => 'Withdrawn',
      StudentStatus.archived => 'Archived',
    };
  }

  String get displayNameAr {
    return switch (this) {
      StudentStatus.lead => 'عميل محتمل',
      StudentStatus.applicant => 'مقدم طلب',
      StudentStatus.active => 'نشط',
      StudentStatus.suspended => 'معلق',
      StudentStatus.graduated => 'متخرج',
      StudentStatus.withdrawn => 'منسحب',
      StudentStatus.archived => 'مؤرشف',
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
