import 'package:freezed_annotation/freezed_annotation.dart';

part 'school_class.freezed.dart';
part 'school_class.g.dart';

/// School Class entity.
///
/// Maps to the classes table in Supabase.
/// Using 'school_class' to avoid Dart keyword conflict.
@freezed
abstract class SchoolClass with _$SchoolClass {
  const factory SchoolClass({
    required String id,
    required String organizationId,
    required String branchId,
    required String name,
    String? description,
    String? roomId,
    String? teacherId,
    required ClassLevel level,
    @Default([]) List<String> daysOfWeek,
    String? startTime,
    String? endTime,
    @Default(30) int maxCapacity,
    @Default(ClassStatus.active) ClassStatus status,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _SchoolClass;

  factory SchoolClass.fromJson(Map<String, dynamic> json) =>
      _$SchoolClassFromJson(json);
}

/// Class level in the Qur'an curriculum.
enum ClassLevel {
  beginner,
  elementary,
  intermediate,
  advanced,
  hafiz,
}

/// Class status.
enum ClassStatus {
  active,
  inactive,
  completed,
  cancelled,
}

/// Extension for display names.
extension ClassLevelExtension on ClassLevel {
  String get displayName {
    return switch (this) {
      ClassLevel.beginner => 'Beginner',
      ClassLevel.elementary => 'Elementary',
      ClassLevel.intermediate => 'Intermediate',
      ClassLevel.advanced => 'Advanced',
      ClassLevel.hafiz => 'Hafiz',
    };
  }

  String get displayNameAr {
    return switch (this) {
      ClassLevel.beginner => 'مبتدئ',
      ClassLevel.elementary => 'ابتدائي',
      ClassLevel.intermediate => 'متوسط',
      ClassLevel.advanced => 'متقدم',
      ClassLevel.hafiz => 'حافظ',
    };
  }
}

extension ClassStatusExtension on ClassStatus {
  String get displayName {
    return switch (this) {
      ClassStatus.active => 'Active',
      ClassStatus.inactive => 'Inactive',
      ClassStatus.completed => 'Completed',
      ClassStatus.cancelled => 'Cancelled',
    };
  }

  String get displayNameAr {
    return switch (this) {
      ClassStatus.active => 'نشط',
      ClassStatus.inactive => 'غير نشط',
      ClassStatus.completed => 'مكتمل',
      ClassStatus.cancelled => 'ملغي',
    };
  }
}
