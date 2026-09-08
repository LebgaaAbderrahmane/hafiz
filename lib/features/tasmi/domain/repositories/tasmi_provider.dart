import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/tasmi/data/repositories/tasmi_repository_impl.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_repository.dart';

/// Tasmi repository provider.
final tasmiRepositoryProvider = Provider<TasmiRepository>((ref) {
  return TasmiRepositoryImpl();
});

/// Student tasmi sessions provider.
final studentTasmiSessionsProvider = FutureProvider.autoDispose
    .family<List<TasmiSession>, String>((ref, studentId) async {
  final result = await ref
      .read(tasmiRepositoryProvider)
      .getStudentSessions(studentId);
  return result.fold(
    (failure) => throw failure,
    (sessions) => sessions,
  );
});

/// Teacher tasmi sessions provider.
final teacherTasmiSessionsProvider = FutureProvider.autoDispose
    .family<List<TasmiSession>, String>((ref, teacherId) async {
  final result = await ref
      .read(tasmiRepositoryProvider)
      .getTeacherSessions(teacherId);
  return result.fold(
    (failure) => throw failure,
    (sessions) => sessions,
  );
});

/// Single tasmi session provider.
final tasmiSessionProvider =
    FutureProvider.autoDispose.family<TasmiSession, String>((ref, id) async {
  final result = await ref.read(tasmiRepositoryProvider).getSession(id);
  return result.fold(
    (failure) => throw failure,
    (session) => session,
  );
});
