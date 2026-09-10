import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

/// Attendance entity.
///
/// Records student attendance for a session.
@freezed
abstract class Attendance with _$Attendance {
  factory Attendance({
    required String id,
    required String organizationId,
    required String branchId,
    required String studentId,
    required String sessionId,
    required String classId,
    required AttendanceStatus status,
    String? checkInTime,
    String? checkOutTime,
    String? notes,
    String? markedBy,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);
}

/// Attendance status.
enum AttendanceStatus {
  present,
  late,
  absent,
  excused,
  leftEarly,
}

/// Extension for display names.
extension AttendanceStatusExtension on AttendanceStatus {
  String get displayName {
    return switch (this) {
      AttendanceStatus.present => 'Present',
      AttendanceStatus.late => 'Late',
      AttendanceStatus.absent => 'Absent',
      AttendanceStatus.excused => 'Excused',
      AttendanceStatus.leftEarly => 'Left Early',
    };
  }

  String get displayNameAr {
    return switch (this) {
      AttendanceStatus.present => 'حاضر',
      AttendanceStatus.late => 'متأخر',
      AttendanceStatus.absent => 'غائب',
      AttendanceStatus.excused => 'مبرر',
      AttendanceStatus.leftEarly => 'رحل مبكراً',
    };
  }

  int get colorValue {
    return switch (this) {
      AttendanceStatus.present => 0xFF2D9D78,
      AttendanceStatus.late => 0xFFD4A843,
      AttendanceStatus.absent => 0xFFD44343,
      AttendanceStatus.excused => 0xFF4A90D9,
      AttendanceStatus.leftEarly => 0xFF9B59B6,
    };
  }
}
