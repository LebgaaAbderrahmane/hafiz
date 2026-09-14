import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/tasmi/data/repositories/tasmi_repository_impl.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_repository.dart';

/// Tasmi repository provider.
final tasmiRepositoryProvider = Provider<TasmiRepository>((ref) {
  return TasmiRepositoryImpl(supabase);
});

/// All tasmi sessions for the current branch (paginated).
final branchTasmiSessionsProvider =
    AsyncNotifierProvider.autoDispose<TasmiSessionsNotifier, List<TasmiSession>>(
        TasmiSessionsNotifier.new);

/// Tasmi sessions notifier with pagination.
class TasmiSessionsNotifier extends AutoDisposeAsyncNotifier<List<TasmiSession>> {
  @override
  Future<List<TasmiSession>> build() async {
    final orgId = ref.watch(activeOrganizationIdProvider);
    if (orgId == null) return [];
    final data = await supabase
        .from('tasmi_sessions')
        .select('id, student_id, teacher_id, organization_id, session_id, class_id, start_surah, start_ayah, end_surah, end_ayah, session_type, outcome, accuracy_score, tajwid_score, fluency_score, pronunciation_score, confidence_score, overall_rating, notes, recorded_at, created_at')
        .eq('organization_id', orgId)
        .order('recorded_at', ascending: false)
        .limit(50);
    return (data as List)
        .map((json) => TasmiSession.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Load more sessions.
  Future<void> loadMore() async {
    final current = state.valueOrNull ?? [];
    final orgId = ref.read(activeOrganizationIdProvider);
    if (orgId == null) return;

    final data = await supabase
        .from('tasmi_sessions')
        .select('id, student_id, teacher_id, organization_id, session_id, class_id, start_surah, start_ayah, end_surah, end_ayah, session_type, outcome, accuracy_score, tajwid_score, fluency_score, pronunciation_score, confidence_score, overall_rating, notes, recorded_at, created_at')
        .eq('organization_id', orgId)
        .order('recorded_at', ascending: false)
        .range(current.length, current.length + 49);

    final newSessions = (data as List)
        .map((json) => TasmiSession.fromJson(json as Map<String, dynamic>))
        .toList();
    state = AsyncData([...current, ...newSessions]);
  }
}

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
