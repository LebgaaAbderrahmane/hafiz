import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/guardians/domain/entities/guardian.dart';
import 'package:hafiz/features/guardians/domain/repositories/guardian_repository.dart';
import 'package:hafiz/features/guardians/data/repositories/guardian_repository_impl.dart';

/// Guardian repository provider.
final guardianRepositoryProvider = Provider<GuardianRepository>((ref) {
  return GuardianRepositoryImpl(Supabase.instance.client);
});

/// Branch guardians provider.
final branchGuardiansProvider =
    FutureProvider.autoDispose.family<List<Guardian>, String>((ref, branchId) async {
  final repo = ref.watch(guardianRepositoryProvider);
  return repo.getBranchGuardians(branchId: branchId);
});

/// Student guardians provider.
final studentGuardiansProvider =
    FutureProvider.autoDispose.family<List<Guardian>, String>((ref, studentId) async {
  final repo = ref.watch(guardianRepositoryProvider);
  return repo.getStudentGuardians(studentId);
});

/// Guardian notifier for CRUD operations.
class GuardianNotifier extends StateNotifier<AsyncValue<void>> {
  final GuardianRepository _repository;

  GuardianNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<Guardian> createGuardian(Guardian guardian) async {
    state = const AsyncValue.loading();
    try {
      final created = await _repository.createGuardian(guardian);
      state = const AsyncValue.data(null);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateGuardian(Guardian guardian) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateGuardian(guardian);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteGuardian(String guardianId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteGuardian(guardianId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> linkGuardianToStudent({
    required String guardianId,
    required String studentId,
    required String relationship,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.linkGuardianToStudent(
        guardianId: guardianId,
        studentId: studentId,
        relationship: relationship,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Guardian notifier provider.
final guardianNotifierProvider =
    StateNotifierProvider<GuardianNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(guardianRepositoryProvider);
  return GuardianNotifier(repo);
});
