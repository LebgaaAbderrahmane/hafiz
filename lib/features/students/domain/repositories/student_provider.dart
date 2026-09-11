import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/students/data/repositories/student_repository_impl.dart';
import 'package:hafiz/features/students/domain/entities/student.dart';
import 'package:hafiz/features/students/domain/repositories/student_repository.dart';

/// Student repository provider.
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepositoryImpl();
});

/// Students list provider.
final studentsProvider =
    AsyncNotifierProvider.autoDispose<StudentsNotifier, List<Student>>(StudentsNotifier.new);

/// Students notifier.
class StudentsNotifier extends AutoDisposeAsyncNotifier<List<Student>> {
  @override
  Future<List<Student>> build() async {
    final orgId = ref.watch(activeOrganizationIdProvider);
    if (orgId == null) return [];

    final result = await ref.read(studentRepositoryProvider).getStudents(
          organizationId: orgId,
        );

    return result.fold(
      (failure) => throw failure,
      (students) => students,
    );
  }

  /// Refresh students list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// Load more students.
  Future<void> loadMore() async {
    final current = state.valueOrNull ?? [];
    final orgId = ref.read(activeOrganizationIdProvider);
    if (orgId == null) return;

    final result = await ref.read(studentRepositoryProvider).getStudents(
          organizationId: orgId,
          offset: current.length,
        );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (students) => state = AsyncData([...current, ...students]),
    );
  }

  /// Delete student.
  Future<void> deleteStudent(String id) async {
    final result = await ref.read(studentRepositoryProvider).deleteStudent(id);
    result.fold(
      (failure) => throw failure,
      (_) {
        final current = state.valueOrNull ?? [];
        state = AsyncData(current.where((s) => s.id != id).toList());
      },
    );
  }
}

/// Single student provider.
final studentProvider =
    FutureProvider.autoDispose.family<Student, String>((ref, id) async {
  final result = await ref.read(studentRepositoryProvider).getStudent(id);
  return result.fold(
    (failure) => throw failure,
    (student) => student,
  );
});
