import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:hafiz/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:hafiz/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_provider.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const DashboardStats();
  }
  return repo.getDashboardStats(user.id);
});

final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return 0;
  return repo.getUnreadNotificationCount(user.id);
});
