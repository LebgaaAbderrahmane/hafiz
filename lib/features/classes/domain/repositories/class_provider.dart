import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/classes/data/repositories/class_repository_impl.dart';
import 'package:hafiz/features/classes/domain/entities/school_class.dart';
import 'package:hafiz/features/classes/domain/repositories/class_repository.dart';

/// Class repository provider.
final classRepositoryProvider = Provider<ClassRepository>((ref) {
  return ClassRepositoryImpl();
});

/// Classes list provider.
final classesProvider =
    AsyncNotifierProvider.autoDispose<ClassesNotifier, List<SchoolClass>>(
        ClassesNotifier.new);

/// Classes notifier.
class ClassesNotifier extends AutoDisposeAsyncNotifier<List<SchoolClass>> {
  @override
  Future<List<SchoolClass>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];

    final result = await ref.read(classRepositoryProvider).getClasses(
          organizationId: user.id,
        );

    return result.fold(
      (failure) => throw failure,
      (classes) => classes,
    );
  }

  /// Refresh classes list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// Delete class.
  Future<void> deleteClass(String id) async {
    final result = await ref.read(classRepositoryProvider).deleteClass(id);
    result.fold(
      (failure) => throw failure,
      (_) {
        final current = state.valueOrNull ?? [];
        state = AsyncData(current.where((c) => c.id != id).toList());
      },
    );
  }
}

/// Single class provider.
final classProvider =
    FutureProvider.autoDispose.family<SchoolClass, String>((ref, id) async {
  final result = await ref.read(classRepositoryProvider).getClass(id);
  return result.fold(
    (failure) => throw failure,
    (schoolClass) => schoolClass,
  );
});
