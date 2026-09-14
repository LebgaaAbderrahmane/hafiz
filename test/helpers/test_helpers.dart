import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/entities/user.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:hafiz/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:hafiz/features/dashboard/domain/repositories/dashboard_provider.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_repository.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_provider.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:mocktail/mocktail.dart';

/// Mock AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock DashboardRepository
class MockDashboardRepository extends Mock implements DashboardRepository {}

/// Mock TasmiRepository
class MockTasmiRepository extends Mock implements TasmiRepository {}

/// Sample AppUser for testing
AppUser createTestUser({
  String id = 'test-user-id',
  String email = 'test@example.com',
  String fullName = 'Test User',
}) {
  return AppUser(
    id: id,
    email: email,
    fullName: fullName,
    language: 'ar',
    isActive: true,
    createdAt: DateTime(2026),
  );
}

/// Sample UserRole for testing
UserRole createTestUserRole({
  String id = 'test-role-id',
  String userId = 'test-user-id',
  String organizationId = 'test-org-id',
  String? branchId = 'test-branch-id',
  Role role = Role.owner,
}) {
  return UserRole(
    id: id,
    userId: userId,
    organizationId: organizationId,
    branchId: branchId,
    role: role,
    createdAt: DateTime(2026),
  );
}

/// Sample DashboardStats for testing
DashboardStats createTestDashboardStats({
  int totalStudents = 50,
  int activeStudents = 40,
  int totalTeachers = 10,
  int totalClasses = 8,
  int todaySessions = 5,
}) {
  return DashboardStats(
    totalStudents: totalStudents,
    activeStudents: activeStudents,
    totalTeachers: totalTeachers,
    totalClasses: totalClasses,
    todaySessions: todaySessions,
  );
}

/// Sample TasmiSession for testing
TasmiSession createTestTasmiSession({
  String id = 'test-session-id',
  String studentId = 'student-id-12345678',
  String teacherId = 'teacher-id-12345678',
  TasmiOutcome outcome = TasmiOutcome.pass,
  int startSurah = 1,
  int startAyah = 1,
  int endSurah = 1,
  int endAyah = 7,
}) {
  return TasmiSession(
    id: id,
    organizationId: 'test-org-id',
    branchId: 'test-branch-id',
    studentId: studentId,
    teacherId: teacherId,
    sessionId: 'session-id',
    startSurah: startSurah,
    startAyah: startAyah,
    endSurah: endSurah,
    endAyah: endAyah,
    sessionType: TasmiSessionType.newMemorization,
    outcome: outcome,
    accuracyScore: 8,
    tajwidScore: 9,
    fluencyScore: 7,
    overallRating: 8,
    recordedAt: DateTime.now(),
    createdAt: DateTime.now(),
  );
}

/// Wraps a widget in a MaterialApp for testing.
Widget wrapInApp(Widget child) {
  return MaterialApp(
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(body: child),
    ),
  );
}

/// Wraps a widget with ProviderContainer for widget testing.
Widget wrapInProviderContainer(
  Widget child, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: child),
      ),
    ),
  );
}
