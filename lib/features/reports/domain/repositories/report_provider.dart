import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/report.dart';
import '../domain/repositories/report_repository.dart';
import '../data/repositories/report_repository_impl.dart';

/// Report repository provider.
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ReportRepositoryImpl(client);
});

/// Branch reports provider.
final branchReportsProvider =
    FutureProvider.autoDispose.family<List<Report>, String>((ref, branchId) async {
  final repo = ref.watch(reportRepositoryProvider);
  return repo.getBranchReports(branchId: branchId);
});

/// Report notifier for generating reports.
class ReportNotifier extends StateNotifier<AsyncValue<void>> {
  final ReportRepository _repository;

  ReportNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<Report> generateReport({
    required String organizationId,
    required String branchId,
    required String generatedById,
    required ReportType type,
    required String title,
    Map<String, dynamic>? parameters,
    ReportFormat? format,
  }) async {
    state = const AsyncValue.loading();
    try {
      final report = await _repository.generateReport(
        organizationId: organizationId,
        branchId: branchId,
        generatedById: generatedById,
        type: type,
        title: title,
        parameters: parameters,
        format: format,
      );
      state = const AsyncValue.data(null);
      return report;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteReport(String reportId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteReport(reportId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Report notifier provider.
final reportNotifierProvider =
    StateNotifierProvider<ReportNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(reportRepositoryProvider);
  return ReportNotifier(repo);
});
