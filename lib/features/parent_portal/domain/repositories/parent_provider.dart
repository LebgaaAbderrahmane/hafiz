import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/parent_portal/data/repositories/parent_repository_impl.dart';
import 'package:hafiz/features/parent_portal/domain/entities/parent_student.dart';
import 'package:hafiz/features/parent_portal/domain/repositories/parent_repository.dart';

/// Parent repository provider.
final parentRepositoryProvider = Provider<ParentRepository>((ref) {
  return ParentRepositoryImpl();
});

/// Currently selected student ID (for tab switching).
final selectedStudentIdProvider = StateProvider<String?>((ref) => null);

/// Linked students for the current parent.
final parentStudentsProvider =
    AsyncNotifierProvider.autoDispose<ParentStudentsNotifier, List<ParentStudent>>(
  ParentStudentsNotifier.new,
);

/// Parent students notifier.
class ParentStudentsNotifier extends AutoDisposeAsyncNotifier<List<ParentStudent>> {
  @override
  Future<List<ParentStudent>> build() async {
    final user = ref.watch(currentUserProvider);
    final orgId = ref.watch(activeOrganizationIdProvider);
    if (user == null || orgId == null) return [];

    final result = await ref.read(parentRepositoryProvider).getLinkedStudents(
          parentId: user.id,
          organizationId: orgId,
        );

    return result.fold(
      (failure) => throw failure,
      (students) {
        // Auto-select first student if none selected.
        final selected = ref.read(selectedStudentIdProvider);
        if (selected == null && students.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedStudentIdProvider.notifier).state =
                students.first.studentId;
          });
        }
        return students;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

/// Currently selected student entity.
final selectedStudentProvider = Provider<ParentStudent?>((ref) {
  final students = ref.watch(parentStudentsProvider).valueOrNull ?? [];
  final selectedId = ref.watch(selectedStudentIdProvider);
  if (selectedId == null || students.isEmpty) return null;
  try {
    return students.firstWhere((s) => s.studentId == selectedId);
  } catch (_) {
    return students.isNotEmpty ? students.first : null;
  }
});

/// Attendance records for the selected student in a given month.
final parentAttendanceProvider = FutureProvider.autoDispose
    .family<List<ParentAttendanceRecord>, ({String studentId, DateTime month})>(
        (ref, params) async {
  final start = DateTime(params.month.year, params.month.month, 1);
  final end = DateTime(params.month.year, params.month.month + 1, 0);

  final result = await ref.read(parentRepositoryProvider).getStudentAttendance(
        studentId: params.studentId,
        startDate: start,
        endDate: end,
      );

  return result.fold(
    (failure) => throw failure,
    (records) => records,
  );
});

/// Recent tasmi sessions for a student.
final parentTasmiSessionsProvider = FutureProvider.autoDispose
    .family<List<ParentTasmiSummary>, String>((ref, studentId) async {
  final result =
      await ref.read(parentRepositoryProvider).getRecentTasmiSessions(
            studentId: studentId,
          );

  return result.fold(
    (failure) => throw failure,
    (sessions) => sessions,
  );
});

/// Upcoming sessions for a student.
final parentUpcomingSessionsProvider = FutureProvider.autoDispose
    .family<List<ParentUpcomingSession>, String>((ref, studentId) async {
  final orgId = ref.watch(activeOrganizationIdProvider);
  if (orgId == null) return [];

  final result =
      await ref.read(parentRepositoryProvider).getUpcomingSessions(
            studentId: studentId,
            organizationId: orgId,
          );

  return result.fold(
    (failure) => throw failure,
    (sessions) => sessions,
  );
});
