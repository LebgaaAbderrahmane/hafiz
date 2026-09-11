import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/tasmi/data/repositories/tasmi_repository_impl.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_repository.dart';

/// Tasmi repository provider.
final tasmiRepositoryProvider = Provider<TasmiRepository>((ref) {
  return TasmiRepositoryImpl(supabase);
});

/// Student tasmi sessions provider.
final studentTasmiSessionsProvider = FutureProvider.autoDispose
    .family<List<TasmiSession>, String>((ref, studentId) async {
  return ref
      .read(tasmiRepositoryProvider)
      .getStudentSessions(studentId);
});

/// Teacher tasmi sessions provider.
final teacherTasmiSessionsProvider = FutureProvider.autoDispose
    .family<List<TasmiSession>, String>((ref, teacherId) async {
  return ref
      .read(tasmiRepositoryProvider)
      .getTeacherSessions(teacherId);
});

/// Single tasmi session provider.
final tasmiSessionProvider =
    FutureProvider.autoDispose.family<TasmiSession?, String>((ref, id) async {
  return ref.read(tasmiRepositoryProvider).getSession(id);
});
