import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/teachers/domain/entities/teacher.dart';
import 'package:hafiz/features/teachers/domain/repositories/teacher_repository.dart';
import 'package:hafiz/features/teachers/data/repositories/teacher_repository_impl.dart';
import 'package:hafiz/core/network/supabase_client.dart';

/// Teacher repository provider.
final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TeacherRepositoryImpl(client);
});

/// Branch teachers provider.
final branchTeachersProvider =
    FutureProvider.autoDispose.family<List<Teacher>, String>((ref, branchId) async {
  final repo = ref.watch(teacherRepositoryProvider);
  return repo.getBranchTeachers(branchId: branchId);
});

/// Teacher notifier for CRUD operations.
class TeacherNotifier extends StateNotifier<AsyncValue<void>> {
  final TeacherRepository _repository;

  TeacherNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<Teacher> createTeacher(Teacher teacher) async {
    state = const AsyncValue.loading();
    try {
      final created = await _repository.createTeacher(teacher);
      state = const AsyncValue.data(null);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateTeacher(Teacher teacher) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateTeacher(teacher);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteTeacher(String teacherId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTeacher(teacherId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Teacher notifier provider.
final teacherNotifierProvider =
    StateNotifierProvider<TeacherNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(teacherRepositoryProvider);
  return TeacherNotifier(repo);
});
