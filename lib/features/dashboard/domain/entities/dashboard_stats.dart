import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @Default(0) int totalStudents,
    @Default(0) int activeStudents,
    @Default(0) int totalTeachers,
    @Default(0) int totalClasses,
    @Default(0) int todaySessions,
    @Default(0) int pendingAssignments,
    @Default(0) int completedAssignments,
    @Default(0) int overdueAssignments,
    @Default(0) int unreadNotifications,
  }) = _DashboardStats;
}
