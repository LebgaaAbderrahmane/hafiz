import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/revision/domain/entities/revision.dart';
import 'package:hafiz/features/revision/domain/repositories/revision_repository.dart';
import 'package:hafiz/features/revision/data/repositories/revision_repository_impl.dart';

/// Revision repository provider.
final revisionRepositoryProvider = Provider<RevisionRepository>((ref) {
  return RevisionRepositoryImpl(Supabase.instance.client);
});

/// Student revisions provider.
final studentRevisionsProvider =
    FutureProvider.autoDispose.family<List<Revision>, String>((ref, studentId) async {
  final repo = ref.watch(revisionRepositoryProvider);
  return repo.getStudentRevisions(studentId: studentId);
});

/// Student overdue revisions provider.
final studentOverdueRevisionsProvider =
    FutureProvider.autoDispose.family<List<Revision>, String>((ref, studentId) async {
  final repo = ref.watch(revisionRepositoryProvider);
  return repo.getOverdueRevisions(studentId);
});

/// Student upcoming revisions provider.
final studentUpcomingRevisionsProvider =
    FutureProvider.autoDispose.family<List<Revision>, String>((ref, studentId) async {
  final repo = ref.watch(revisionRepositoryProvider);
  return repo.getUpcomingRevisions(studentId);
});

/// Student revision stats provider.
final studentRevisionStatsProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, studentId) async {
  final repo = ref.watch(revisionRepositoryProvider);
  return repo.getStudentRevisionStats(studentId);
});

/// Teacher revisions provider.
final teacherRevisionsProvider =
    FutureProvider.autoDispose.family<List<Revision>, String>((ref, teacherId) async {
  final repo = ref.watch(revisionRepositoryProvider);
  return repo.getTeacherRevisions(teacherId: teacherId);
});

/// Branch revisions provider.
final branchRevisionsProvider =
    FutureProvider.autoDispose.family<List<Revision>, String>((ref, branchId) async {
  final repo = ref.watch(revisionRepositoryProvider);
  return repo.getBranchRevisions(branchId: branchId);
});

/// Revision notifier for creating/updating revisions.
class RevisionNotifier extends StateNotifier<AsyncValue<void>> {
  final RevisionRepository _repository;

  RevisionNotifier(this._repository) : super(const AsyncData(null));

  Future<Revision> createRevision(Revision revision) async {
    state = const AsyncLoading();
    try {
      final created = await _repository.createRevision(revision);
      state = const AsyncData(null);
      return created;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateRevision(Revision revision) async {
    state = const AsyncLoading();
    try {
      await _repository.updateRevision(revision);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteRevision(String revisionId) async {
    state = const AsyncLoading();
    try {
      await _repository.deleteRevision(revisionId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> completeRevision({
    required String revisionId,
    required int qualityScore,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.completeRevision(
        revisionId: revisionId,
        qualityScore: qualityScore,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// Revision notifier provider.
final revisionNotifierProvider =
    StateNotifierProvider<RevisionNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(revisionRepositoryProvider);
  return RevisionNotifier(repo);
});
