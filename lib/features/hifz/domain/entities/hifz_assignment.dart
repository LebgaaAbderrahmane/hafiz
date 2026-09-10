import 'package:freezed_annotation/freezed_annotation.dart';

part 'hifz_assignment.freezed.dart';
part 'hifz_assignment.g.dart';

/// HifzAssignment entity.
///
/// Represents a memorization assignment given to a student.
@freezed
abstract class HifzAssignment with _$HifzAssignment {
  factory HifzAssignment({
    required String id,
    required String organizationId,
    required String branchId,
    required String studentId,
    required String teacherId,
    String? classId,
    required int startSurah,
    required int startAyah,
    required int endSurah,
    required int endAyah,
    required AssignmentType type,
    required AssignmentStatus status,
    DateTime? dueDate,
    String? notes,
    int? qualityTarget,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) = _HifzAssignment;

  factory HifzAssignment.fromJson(Map<String, dynamic> json) =>
      _$HifzAssignmentFromJson(json);
}

/// Assignment type.
enum AssignmentType {
  newMemorization,
  revision,
  comprehensiveRevision,
}

/// Assignment status.
enum AssignmentStatus {
  pending,
  inProgress,
  completed,
  overdue,
  cancelled,
}

/// Extension for display names.
extension AssignmentTypeExtension on AssignmentType {
  String get displayNameAr {
    return switch (this) {
      AssignmentType.newMemorization => 'حفظ جديد',
      AssignmentType.revision => 'مراجعة',
      AssignmentType.comprehensiveRevision => 'مراجعة شاملة',
    };
  }
}

extension AssignmentStatusExtension on AssignmentStatus {
  String get displayNameAr {
    return switch (this) {
      AssignmentStatus.pending => 'قيد الانتظار',
      AssignmentStatus.inProgress => 'قيد التنفيذ',
      AssignmentStatus.completed => 'مكتمل',
      AssignmentStatus.overdue => 'متأخر',
      AssignmentStatus.cancelled => 'ملغي',
    };
  }

  int get colorValue {
    return switch (this) {
      AssignmentStatus.pending => 0xFF9E9E9E,
      AssignmentStatus.inProgress => 0xFF4A90D9,
      AssignmentStatus.completed => 0xFF2D9D78,
      AssignmentStatus.overdue => 0xFFD44343,
      AssignmentStatus.cancelled => 0xFF9B59B6,
    };
  }
}
