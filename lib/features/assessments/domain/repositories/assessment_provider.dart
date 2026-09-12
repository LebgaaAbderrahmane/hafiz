import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/assessments/data/repositories/assessment_repository.dart';
import 'package:hafiz/features/assessments/domain/entities/assessment.dart';

/// Assessment repository provider.
final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return AssessmentRepository(Supabase.instance.client);
});

/// Branch assessments provider.
final branchAssessmentsProvider = FutureProvider.autoDispose
    .family<List<Assessment>, String>((ref, branchId) async {
  return ref.read(assessmentRepositoryProvider).getBranchAssessments(
        branchId: branchId,
      );
});

/// Single assessment provider.
final assessmentProvider =
    FutureProvider.family<Assessment, String>((ref, id) async {
  return ref.read(assessmentRepositoryProvider).getAssessment(id);
});

/// Assessment results provider.
final assessmentResultsProvider = FutureProvider.autoDispose
    .family<List<AssessmentResult>, String>((ref, assessmentId) async {
  return ref
      .read(assessmentRepositoryProvider)
      .getAssessmentResults(assessmentId);
});
