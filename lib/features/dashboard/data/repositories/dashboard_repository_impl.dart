import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/dashboard/domain/entities/dashboard_stats.dart';
import 'dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final _client = supabase;

  @override
  Future<DashboardStats> getDashboardStats(String organizationId) async {
    final results = await Future.wait([
      _client.from('students').select('id, status').eq('organization_id', organizationId),
      _client.from('teachers').select('id').eq('organization_id', organizationId),
      _client.from('classes').select('id').eq('organization_id', organizationId),
      _client.from('hifz_assignments').select('id, status').eq('organization_id', organizationId),
    ]);

    final students = results[0] as List;
    final teachers = results[1] as List;
    final classes = results[2] as List;
    final assignments = results[3] as List;

    return DashboardStats(
      totalStudents: students.length,
      activeStudents: students.where((s) => s['status'] == 'active').length,
      totalTeachers: teachers.length,
      totalClasses: classes.length,
      todaySessions: 0,
      pendingAssignments: assignments.where((a) => a['status'] == 'pending').length,
      completedAssignments: assignments.where((a) => a['status'] == 'completed').length,
      overdueAssignments: assignments.where((a) => a['status'] == 'overdue').length,
      unreadNotifications: 0,
    );
  }

  @override
  Future<int> getUnreadNotificationCount(String userId) async {
    final result = await _client
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false);
    return result.length;
  }
}
