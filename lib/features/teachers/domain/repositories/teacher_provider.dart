import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/teachers/data/repositories/teacher_repository_impl.dart';
import 'package:hafiz/features/teachers/domain/entities/teacher.dart';
import 'package:hafiz/features/teachers/domain/repositories/teacher_repository.dart';

/// Teacher repository provider.
final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepositoryImpl();
});

/// Teachers list provider.
final teachersProvider =
    AsyncNotifierProvider.autoDispose<TeachersNotifier, List<Teacher>>(
        TeachersNotifier.new);

/// Teachers notifier.
class TeachersNotifier extends AutoDisposeAsyncNotifier<List<Teacher>> {
  @override
  Future<List<Teacher>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];

    final result = await ref.read(teacherRepositoryProvider).getTeachers(
          organizationId: user.id,
        );

    return result.fold(
      (failure) => throw failure,
      (teachers) => teachers,
    );
  }

  /// Refresh teachers list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// Load more teachers.
  Future<void> loadMore() async {
    final current = state.valueOrNull ?? [];
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final result = await ref.read(teacherRepositoryProvider).getTeachers(
          organizationId: user.id,
          offset: current.length,
        );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (teachers) => state = AsyncData([...current, ...teachers]),
    );
  }

  /// Delete teacher.
  Future<void> deleteTeacher(String id) async {
    final result =
        await ref.read(teacherRepositoryProvider).deleteTeacher(id);
    result.fold(
      (failure) => throw failure,
      (_) {
        final current = state.valueOrNull ?? [];
        state = AsyncData(current.where((t) => t.id != id).toList());
      },
    );
  }
}

/// Single teacher provider.
final teacherProvider =
    FutureProvider.autoDispose.family<Teacher, String>((ref, id) async {
  final result = await ref.read(teacherRepositoryProvider).getTeacher(id);
  return result.fold(
    (failure) => throw failure,
    (teacher) => teacher,
  );
});
