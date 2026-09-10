import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_event.freezed.dart';
part 'schedule_event.g.dart';

/// Schedule Event entity.
///
/// Represents a scheduled event (class, session, exam, etc.).
@freezed
abstract class ScheduleEvent with _$ScheduleEvent {
  factory ScheduleEvent({
    required String id,
    required String organizationId,
    required String branchId,
    required String title,
    String? description,
    required EventType eventType,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? classId,
    String? teacherId,
    @Default([]) List<String> studentIds,
    @Default([]) List<String> recurrenceDays,
    String? recurrenceEndDate,
    @Default(EventStatus.scheduled) EventStatus status,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ScheduleEvent;

  factory ScheduleEvent.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEventFromJson(json);
}

/// Event type.
enum EventType {
  classSession,
  tasmi,
  exam,
  meeting,
  holiday,
  other,
}

/// Event status.
enum EventStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  rescheduled,
}

/// Extension for display names.
extension EventTypeExtension on EventType {
  String get displayName {
    return switch (this) {
      EventType.classSession => 'Class Session',
      EventType.tasmi => "Tasmi'",
      EventType.exam => 'Exam',
      EventType.meeting => 'Meeting',
      EventType.holiday => 'Holiday',
      EventType.other => 'Other',
    };
  }

  String get displayNameAr {
    return switch (this) {
      EventType.classSession => 'حصة دراسية',
      EventType.tasmi => 'تسميع',
      EventType.exam => 'امتحان',
      EventType.meeting => 'اجتماع',
      EventType.holiday => 'عطلة',
      EventType.other => 'أخرى',
    };
  }
}

extension EventStatusExtension on EventStatus {
  String get displayName {
    return switch (this) {
      EventStatus.scheduled => 'Scheduled',
      EventStatus.inProgress => 'In Progress',
      EventStatus.completed => 'Completed',
      EventStatus.cancelled => 'Cancelled',
      EventStatus.rescheduled => 'Rescheduled',
    };
  }

  String get displayNameAr {
    return switch (this) {
      EventStatus.scheduled => 'مجدول',
      EventStatus.inProgress => 'قيد التنفيذ',
      EventStatus.completed => 'مكتمل',
      EventStatus.cancelled => 'ملغي',
      EventStatus.rescheduled => 'تمت الإعادة جدولة',
    };
  }
}
