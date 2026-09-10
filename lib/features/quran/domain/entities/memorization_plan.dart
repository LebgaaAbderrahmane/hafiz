import 'package:freezed_annotation/freezed_annotation.dart';

part 'memorization_plan.freezed.dart';
part 'memorization_plan.g.dart';

/// Memorization Plan entity.
///
/// Represents a student's Qur'an memorization plan.
@freezed
abstract class MemorizationPlan with _$MemorizationPlan {
  factory MemorizationPlan({
    required String id,
    required String studentId,
    required String teacherId,
    required String organizationId,
    String? classId,
    required MemorizationStatus status,
    required MemorizationPriority priority,
    required int currentSurah,
    required int currentAyah,
    required int targetSurah,
    required int targetAyah,
    @Default([]) List<MemorizationCheckpoint> checkpoints,
    @Default([]) List<MemorizationSession> sessions,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) = _MemorizationPlan;

  factory MemorizationPlan.fromJson(Map<String, dynamic> json) =>
      _$MemorizationPlanFromJson(json);
}

/// Memorization checkpoint.
@freezed
abstract class MemorizationCheckpoint with _$MemorizationCheckpoint {
  factory MemorizationCheckpoint({
    required String id,
    required int surahNumber,
    required int startAyah,
    required int endAyah,
    required CheckpointStatus status,
    int? qualityScore,
    String? teacherNotes,
    DateTime? completedAt,
  }) = _MemorizationCheckpoint;

  factory MemorizationCheckpoint.fromJson(Map<String, dynamic> json) =>
      _$MemorizationCheckpointFromJson(json);
}

/// Memorization session.
@freezed
abstract class MemorizationSession with _$MemorizationSession {
  factory MemorizationSession({
    required String id,
    required DateTime date,
    required int durationMinutes,
    required String fromSurah,
    required int fromAyah,
    required String toSurah,
    required int toAyah,
    int? qualityScore,
    String? notes,
  }) = _MemorizationSession;

  factory MemorizationSession.fromJson(Map<String, dynamic> json) =>
      _$MemorizationSessionFromJson(json);
}

/// Memorization status.
enum MemorizationStatus {
  notStarted,
  inProgress,
  paused,
  completed,
  cancelled,
}

/// Memorization priority.
enum MemorizationPriority {
  low,
  medium,
  high,
}

/// Checkpoint status.
enum CheckpointStatus {
  pending,
  inProgress,
  completed,
  needsRevision,
}

/// Extension for display names.
extension MemorizationStatusExtension on MemorizationStatus {
  String get displayName {
    return switch (this) {
      MemorizationStatus.notStarted => 'Not Started',
      MemorizationStatus.inProgress => 'In Progress',
      MemorizationStatus.paused => 'Paused',
      MemorizationStatus.completed => 'Completed',
      MemorizationStatus.cancelled => 'Cancelled',
    };
  }

  String get displayNameAr {
    return switch (this) {
      MemorizationStatus.notStarted => 'لم يبدأ',
      MemorizationStatus.inProgress => 'قيد التنفيذ',
      MemorizationStatus.paused => 'متوقف',
      MemorizationStatus.completed => 'مكتمل',
      MemorizationStatus.cancelled => 'ملغي',
    };
  }
}

extension MemorizationPriorityExtension on MemorizationPriority {
  String get displayName {
    return switch (this) {
      MemorizationPriority.low => 'Low',
      MemorizationPriority.medium => 'Medium',
      MemorizationPriority.high => 'High',
    };
  }

  String get displayNameAr {
    return switch (this) {
      MemorizationPriority.low => 'منخفض',
      MemorizationPriority.medium => 'متوسط',
      MemorizationPriority.high => 'مرتفع',
    };
  }
}

extension CheckpointStatusExtension on CheckpointStatus {
  String get displayName {
    return switch (this) {
      CheckpointStatus.pending => 'Pending',
      CheckpointStatus.inProgress => 'In Progress',
      CheckpointStatus.completed => 'Completed',
      CheckpointStatus.needsRevision => 'Needs Revision',
    };
  }

  String get displayNameAr {
    return switch (this) {
      CheckpointStatus.pending => 'قيد الانتظار',
      CheckpointStatus.inProgress => 'قيد التنفيذ',
      CheckpointStatus.completed => 'مكتمل',
      CheckpointStatus.needsRevision => 'يحتاج مراجعة',
    };
  }
}
