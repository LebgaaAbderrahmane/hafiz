import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/parent_portal/domain/entities/parent_student.dart';
import 'package:hafiz/features/parent_portal/domain/repositories/parent_repository.dart';

class ParentRepositoryImpl implements ParentRepository {
  @override
  Future<Either<Failure, List<ParentStudent>>> getLinkedStudents({
    required String parentId,
    required String organizationId,
  }) async {
    try {
      final data = await supabase
          .from('student_guardians')
          .select('''
            student_id,
            students (
              id, full_name, preferred_name, avatar_url,
              current_quran_level, memorization_level
            )
          ''')
          .eq('guardian_id', parentId)
          .eq('organization_id', organizationId);

      final students = <ParentStudent>[];
      for (final row in data) {
        final student = row['students'] as Map<String, dynamic>?;
        if (student == null) continue;

        final studentId = student['id'] as String;

        // Fetch attendance stats
        final attendanceData = await supabase
            .from('attendance')
            .select('status')
            .eq('student_id', studentId);

        int attended = 0;
        int missed = 0;
        for (final att in attendanceData) {
          final status = att['status'] as String?;
          if (status == 'present' || status == 'late') {
            attended++;
          } else if (status == 'absent') {
            missed++;
          }
        }
        final total = attended + missed;
        final attendanceRate = total > 0 ? attended / total : 0.0;

        // Fetch tasmi stats
        final tasmiData = await supabase
            .from('tasmi_sessions')
            .select('outcome')
            .eq('student_id', studentId);

        int passCount = 0;
        int needsRevisionCount = 0;
        int failCount = 0;
        for (final t in tasmiData) {
          final outcome = t['outcome'] as String?;
          if (outcome == 'pass') {
            passCount++;
          } else if (outcome == 'needsRevision') {
            needsRevisionCount++;
          } else if (outcome == 'fail') {
            failCount++;
          }
        }

        // Fetch last session date
        final lastSession = await supabase
            .from('tasmi_sessions')
            .select('recorded_at')
            .eq('student_id', studentId)
            .order('recorded_at', ascending: false)
            .limit(1)
            .maybeSingle();

        students.add(ParentStudent(
          id: studentId,
          studentId: studentId,
          fullName: student['full_name'] as String? ?? '',
          preferredName: student['preferred_name'] as String?,
          avatarUrl: student['avatar_url'] as String?,
          currentQuranLevel: student['current_quran_level'] as String?,
          memorizationLevel: student['memorization_level'] as String?,
          totalSessions: total,
          attendedSessions: attended,
          missedSessions: missed,
          attendanceRate: attendanceRate,
          tasmiPassCount: passCount,
          tasmiNeedsRevisionCount: needsRevisionCount,
          tasmiFailCount: failCount,
          lastSessionDate: lastSession != null
              ? DateTime.tryParse(lastSession['recorded_at'] as String? ?? '')
              : null,
        ));
      }

      return Right(students);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ParentAttendanceRecord>>> getStudentAttendance({
    required String studentId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final data = await supabase
          .from('attendance')
          .select('id, student_id, date, status, notes')
          .eq('student_id', studentId)
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String())
          .order('date', ascending: true);

      final records = data
          .map((json) => ParentAttendanceRecord(
                id: json['id'] as String,
                studentId: json['student_id'] as String,
                date: DateTime.parse(json['date'] as String),
                status: json['status'] as String? ?? 'absent',
                notes: json['notes'] as String?,
              ))
          .toList();

      return Right(records);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ParentTasmiSummary>>> getRecentTasmiSessions({
    required String studentId,
    int limit = 10,
  }) async {
    try {
      final data = await supabase
          .from('tasmi_sessions')
          .select('''
            id, student_id, session_type, outcome,
            overall_rating, teacher_notes, recorded_at,
            students (full_name)
          ''')
          .eq('student_id', studentId)
          .order('recorded_at', ascending: false)
          .limit(limit);

      final sessions = data
          .map((json) {
            final student = json['students'] as Map<String, dynamic>?;
            return ParentTasmiSummary(
              id: json['id'] as String,
              studentId: json['student_id'] as String,
              studentName: student?['full_name'] as String? ?? '',
              sessionType: json['session_type'] as String? ?? '',
              outcome: json['outcome'] as String? ?? '',
              overallRating: json['overall_rating'] as int?,
              teacherNotes: json['teacher_notes'] as String?,
              recordedAt:
                  DateTime.parse(json['recorded_at'] as String),
            );
          })
          .toList();

      return Right(sessions);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ParentUpcomingSession>>> getUpcomingSessions({
    required String studentId,
    required String organizationId,
  }) async {
    try {
      final now = DateTime.now();
      final data = await supabase
          .from('sessions')
          .select('''
            id, title, type, date, start_time, end_time,
            location, student_ids
          ''')
          .eq('organization_id', organizationId)
          .gte('date', now.toIso8601String())
          .order('date', ascending: true)
          .limit(20);

      final sessions = <ParentUpcomingSession>[];
      for (final json in data) {
        final studentIds = json['student_ids'] as List<dynamic>? ?? [];
        if (!studentIds.contains(studentId)) continue;

        sessions.add(ParentUpcomingSession(
          id: json['id'] as String,
          title: json['title'] as String? ?? '',
          type: json['type'] as String? ?? '',
          date: DateTime.parse(json['date'] as String),
          startTime: json['start_time'] as String? ?? '',
          endTime: json['end_time'] as String? ?? '',
          location: json['location'] as String?,
          studentName: '',
        ));
      }

      return Right(sessions);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
