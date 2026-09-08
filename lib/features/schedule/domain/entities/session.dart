import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

/// Session entity.
///
/// Represents a specific class session or tasmi' session.
@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    required String organizationId,
    required String branchId,
    required String title,
    String? description,
    required SessionType type,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String classId,
    required String teacherId,
    @Default([]) List<String> studentIds,
    String? location,
    @Default(SessionStatus.scheduled) SessionStatus status,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}

/// Session type.
enum SessionType {
  classSession,
  tasmi,
  revision,
  exam,
  makeup,
  other,
}

/// Session status.
enum SessionStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  rescheduled,
}

/// Extension for display names.
extension SessionTypeExtension on SessionType {
  String get displayName {
    return switch (this) {
      SessionType.classSession => 'Class Session',
      SessionType.tasmi => "Tasmi'",
      SessionType.revision => 'Revision',
      SessionType.exam => 'Exam',
      SessionType.makeup => 'Makeup',
      SessionType.other => 'Other',
    };
  }

  String get displayNameAr {
    return switch (this) {
      SessionType.classSession => 'حصة دراسية',
      SessionType.tasmi => 'تسميع',
      SessionType.revision => 'مراجعة',
      SessionType.exam => 'امتحان',
      SessionType.makeup => 'تعويض',
      SessionType.other => 'أخرى',
    };
  }
}

extension SessionStatusExtension on SessionStatus {
  String get displayName {
    return switch (this) {
      SessionStatus.scheduled => 'Scheduled',
      SessionStatus.inProgress => 'In Progress',
      SessionStatus.completed => 'Completed',
      SessionStatus.cancelled => 'Cancelled',
      SessionStatus.rescheduled => 'Rescheduled',
    };
  }

  String get displayNameAr {
    return switch (this) {
      SessionStatus.scheduled => 'مجدول',
      SessionStatus.inProgress => 'قيد التنفيذ',
      SessionStatus.completed => 'مكتمل',
      SessionStatus.cancelled => 'ملغي',
      SessionStatus.rescheduled => 'تمت الإعادة جدولة',
    };
  }
}
