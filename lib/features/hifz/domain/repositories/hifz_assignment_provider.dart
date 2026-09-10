import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/hifz/domain/entities/hifz_assignment.dart';
import 'package:hafiz/features/hifz/domain/repositories/hifz_assignment_repository.dart';
import 'package:hafiz/features/hifz/data/repositories/hifz_assignment_repository_impl.dart';
import 'package:hafiz/core/network/supabase_client.dart';

/// Hifz assignment repository provider.
final hifzAssignmentRepositoryProvider = Provider<HifzAssignmentRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return HifzAssignmentRepositoryImpl(client);
});

/// Student hifz assignments provider.
final studentHifzAssignmentsProvider =
    FutureProvider.autoDispose.family<List<HifzAssignment>, String>((ref, studentId) async {
  final repo = ref.watch(hifzAssignmentRepositoryProvider);
  return repo.getStudentAssignments(studentId: studentId);
});

/// Teacher hifz assignments provider.
final teacherHifzAssignmentsProvider =
    FutureProvider.autoDispose.family<List<HifzAssignment>, String>((ref, teacherId) async {
  final repo = ref.watch(hifzAssignmentRepositoryProvider);
  return repo.getTeacherAssignments(teacherId: teacherId);
});

/// Branch hifz assignments provider.
final branchHifzAssignmentsProvider =
    FutureProvider.autoDispose.family<List<HifzAssignment>, String>((ref, branchId) async {
  final repo = ref.watch(hifzAssignmentRepositoryProvider);
  return repo.getBranchAssignments(branchId: branchId);
});

/// Hifz assignment notifier for CRUD operations.
class HifzAssignmentNotifier extends StateNotifier<AsyncValue<void>> {
  final HifzAssignmentRepository _repository;

  HifzAssignmentNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<HifzAssignment> createAssignment(HifzAssignment assignment) async {
    state = const AsyncValue.loading();
    try {
      final created = await _repository.createAssignment(assignment);
      state = const AsyncValue.data(null);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateAssignment(HifzAssignment assignment) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateAssignment(assignment);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteAssignment(String assignmentId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteAssignment(assignmentId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> completeAssignment({
    required String assignmentId,
    int? qualityTarget,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.completeAssignment(
        assignmentId: assignmentId,
        qualityTarget: qualityTarget,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Hifz assignment notifier provider.
final hifzAssignmentNotifierProvider =
    StateNotifierProvider<HifzAssignmentNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(hifzAssignmentRepositoryProvider);
  return HifzAssignmentNotifier(repo);
});
