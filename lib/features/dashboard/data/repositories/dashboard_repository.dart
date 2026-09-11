import 'package:hafiz/features/dashboard/domain/entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getDashboardStats(String organizationId);
  Future<int> getUnreadNotificationCount(String userId);
}
