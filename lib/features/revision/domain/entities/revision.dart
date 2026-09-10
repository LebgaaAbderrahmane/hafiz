import 'package:freezed_annotation/freezed_annotation.dart';

part 'revision.freezed.dart';
part 'revision.g.dart';

/// Revision entity.
///
/// Tracks Qur'an revision (muraja'ah) for a student.
@freezed
abstract class Revision with _$Revision {
  factory Revision({
    required String id,
    required String organizationId,
    required String branchId,
    required String studentId,
    required String teacherId,
    String? classId,
    required int surahNumber,
    required int startAyah,
    required int endAyah,
    required RevisionStatus status,
    required RevisionPriority priority,
    DateTime? dueDate,
    DateTime? completedDate,
    int? qualityScore,
    int? reviewCount,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Revision;

  factory Revision.fromJson(Map<String, dynamic> json) =>
      _$RevisionFromJson(json);
}

/// Revision status.
enum RevisionStatus {
  pending,
  due,
  overdue,
  inProgress,
  completed,
  needsRevision,
}

/// Revision priority.
enum RevisionPriority {
  low,
  medium,
  high,
  urgent,
}

/// Extension for display names.
extension RevisionStatusExtension on RevisionStatus {
  String get displayNameAr {
    return switch (this) {
      RevisionStatus.pending => 'قيد الانتظار',
      RevisionStatus.due => 'موعد المراجعة',
      RevisionStatus.overdue => 'متأخر',
      RevisionStatus.inProgress => 'قيد التنفيذ',
      RevisionStatus.completed => 'مكتمل',
      RevisionStatus.needsRevision => 'يحتاج مراجعة',
    };
  }

  int get colorValue {
    return switch (this) {
      RevisionStatus.pending => 0xFF9E9E9E,
      RevisionStatus.due => 0xFF4A90D9,
      RevisionStatus.overdue => 0xFFD44343,
      RevisionStatus.inProgress => 0xFFD4A843,
      RevisionStatus.completed => 0xFF2D9D78,
      RevisionStatus.needsRevision => 0xFFE67E22,
    };
  }
}

extension RevisionPriorityExtension on RevisionPriority {
  String get displayNameAr {
    return switch (this) {
      RevisionPriority.low => 'منخفض',
      RevisionPriority.medium => 'متوسط',
      RevisionPriority.high => 'مرتفع',
      RevisionPriority.urgent => 'عاجل',
    };
  }
}
