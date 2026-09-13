import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:hafiz/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:hafiz/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/core/utils/app_logger.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  final orgId = ref.watch(activeOrganizationIdProvider);
  if (orgId == null) {
    await AppLogger.log('DASHBOARD', 'No org ID, returning empty stats');
    return const DashboardStats();
  }
  try {
    final stats = await repo.getDashboardStats(orgId);
    await AppLogger.log('DASHBOARD', 'Stats loaded: ${stats.totalStudents} students, ${stats.totalTeachers} teachers, ${stats.totalClasses} classes');
    return stats;
  } catch (e, st) {
    await AppLogger.logError('DASHBOARD', e, st);
    rethrow;
  }
});
