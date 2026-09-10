import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/quran/data/repositories/curriculum_repository_impl.dart';
import 'package:hafiz/features/quran/domain/entities/surah.dart';
import 'package:hafiz/features/quran/domain/entities/juz.dart';
import 'package:hafiz/features/quran/domain/entities/memorization_plan.dart';
import 'package:hafiz/features/quran/domain/repositories/curriculum_repository.dart';

/// Curriculum repository provider.
final curriculumRepositoryProvider = Provider<CurriculumRepository>((ref) {
  return CurriculumRepositoryImpl();
});

/// Surahs list provider.
final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  final result = await ref.read(curriculumRepositoryProvider).getSurahs();
  return result.fold(
    (failure) => throw failure,
    (surahs) => surahs,
  );
});

/// Juzs list provider.
final juzsProvider = FutureProvider<List<Juz>>((ref) async {
  final result = await ref.read(curriculumRepositoryProvider).getJuzs();
  return result.fold(
    (failure) => throw failure,
    (juzs) => juzs,
  );
});

/// Single Surah provider.
final surahProvider =
    FutureProvider.family<Surah, int>((ref, number) async {
  final result = await ref.read(curriculumRepositoryProvider).getSurah(number);
  return result.fold(
    (failure) => throw failure,
    (surah) => surah,
  );
});

/// Single Juz provider.
final juzProvider =
    FutureProvider.family<Juz, int>((ref, number) async {
  final result = await ref.read(curriculumRepositoryProvider).getJuz(number);
  return result.fold(
    (failure) => throw failure,
    (juz) => juz,
  );
});

/// Student memorization plans provider.
final studentPlansProvider =
    FutureProvider.family<List<MemorizationPlan>, String>(
        (ref, studentId) async {
  final result = await ref
      .read(curriculumRepositoryProvider)
      .getStudentPlans(studentId);
  return result.fold(
    (failure) => throw failure,
    (plans) => plans,
  );
});

/// Teacher memorization plans provider.
final teacherPlansProvider =
    FutureProvider.family<List<MemorizationPlan>, String>(
        (ref, teacherId) async {
  final result = await ref
      .read(curriculumRepositoryProvider)
      .getTeacherPlans(teacherId);
  return result.fold(
    (failure) => throw failure,
    (plans) => plans,
  );
});

/// Single memorization plan provider.
final memorizationPlanProvider =
    FutureProvider.family<MemorizationPlan, String>((ref, id) async {
  final result =
      await ref.read(curriculumRepositoryProvider).getPlan(id);
  return result.fold(
    (failure) => throw failure,
    (plan) => plan,
  );
});
