import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/schedule/domain/entities/schedule_event.dart';
import 'package:hafiz/features/schedule/domain/entities/session.dart';
import 'package:hafiz/features/schedule/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  @override
  Future<Either<Failure, List<ScheduleEvent>>> getEvents({
    required String organizationId,
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    EventType? type,
    String? classId,
    String? teacherId,
  }) async {
    try {
      var query = supabase
          .from('schedule_events')
          .select()
          .eq('organization_id', organizationId);

      if (branchId != null) {
        query = query.eq('branch_id', branchId);
      }
      if (startDate != null) {
        query = query.gte('start_time', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('end_time', endDate.toIso8601String());
      }
      if (type != null) {
        query = query.eq('event_type', type.name);
      }
      if (classId != null) {
        query = query.eq('class_id', classId);
      }
      if (teacherId != null) {
        query = query.eq('teacher_id', teacherId);
      }

      final data = await query.order('start_time', ascending: true);
      final events =
          data.map((json) => ScheduleEvent.fromJson(json)).toList();
      return Right(events);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ScheduleEvent>> getEvent(String id) async {
    try {
      final data = await supabase
          .from('schedule_events')
          .select()
          .eq('id', id)
          .single();
      return Right(ScheduleEvent.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ScheduleEvent>> createEvent({
    required String organizationId,
    required String branchId,
    required String title,
    String? description,
    required EventType eventType,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? classId,
    String? teacherId,
    List<String>? studentIds,
    List<String>? recurrenceDays,
    String? recurrenceEndDate,
  }) async {
    try {
      final data = await supabase
          .from('schedule_events')
          .insert({
            'organization_id': organizationId,
            'branch_id': branchId,
            'title': title,
            'description': description,
            'event_type': eventType.name,
            'start_time': startTime.toIso8601String(),
            'end_time': endTime.toIso8601String(),
            'location': location,
            'class_id': classId,
            'teacher_id': teacherId,
            'student_ids': studentIds ?? [],
            'recurrence_days': recurrenceDays ?? [],
            'recurrence_end_date': recurrenceEndDate,
          })
          .select()
          .single();
      return Right(ScheduleEvent.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ScheduleEvent>> updateEvent(
    String id, {
    String? title,
    String? description,
    EventType? eventType,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? classId,
    String? teacherId,
    List<String>? studentIds,
    List<String>? recurrenceDays,
    String? recurrenceEndDate,
    EventStatus? status,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (eventType != null) updates['event_type'] = eventType.name;
      if (startTime != null) {
        updates['start_time'] = startTime.toIso8601String();
      }
      if (endTime != null) updates['end_time'] = endTime.toIso8601String();
      if (location != null) updates['location'] = location;
      if (classId != null) updates['class_id'] = classId;
      if (teacherId != null) updates['teacher_id'] = teacherId;
      if (studentIds != null) updates['student_ids'] = studentIds;
      if (recurrenceDays != null) {
        updates['recurrence_days'] = recurrenceDays;
      }
      if (recurrenceEndDate != null) {
        updates['recurrence_end_date'] = recurrenceEndDate;
      }
      if (status != null) updates['status'] = status.name;
      if (notes != null) updates['notes'] = notes;

      final data = await supabase
          .from('schedule_events')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(ScheduleEvent.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String id) async {
    try {
      await supabase.from('schedule_events').delete().eq('id', id);
      return const Right(null);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getSessions({
    required String organizationId,
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    SessionType? type,
    String? classId,
    String? teacherId,
  }) async {
    try {
      var query = supabase
          .from('sessions')
          .select()
          .eq('organization_id', organizationId);

      if (branchId != null) {
        query = query.eq('branch_id', branchId);
      }
      if (startDate != null) {
        query = query.gte('date', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('date', endDate.toIso8601String());
      }
      if (type != null) {
        query = query.eq('type', type.name);
      }
      if (classId != null) {
        query = query.eq('class_id', classId);
      }
      if (teacherId != null) {
        query = query.eq('teacher_id', teacherId);
      }

      final data = await query.order('date', ascending: true);
      final sessions = data.map((json) => Session.fromJson(json)).toList();
      return Right(sessions);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Session>> getSession(String id) async {
    try {
      final data = await supabase
          .from('sessions')
          .select()
          .eq('id', id)
          .single();
      return Right(Session.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Session>> createSession({
    required String organizationId,
    required String branchId,
    required String title,
    String? description,
    required SessionType type,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String classId,
    required String teacherId,
    List<String>? studentIds,
    String? location,
  }) async {
    try {
      final data = await supabase
          .from('sessions')
          .insert({
            'organization_id': organizationId,
            'branch_id': branchId,
            'title': title,
            'description': description,
            'type': type.name,
            'date': date.toIso8601String(),
            'start_time': startTime,
            'end_time': endTime,
            'class_id': classId,
            'teacher_id': teacherId,
            'student_ids': studentIds ?? [],
            'location': location,
          })
          .select()
          .single();
      return Right(Session.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Session>> updateSession(
    String id, {
    String? title,
    String? description,
    SessionType? type,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? classId,
    String? teacherId,
    List<String>? studentIds,
    String? location,
    SessionStatus? status,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (type != null) updates['type'] = type.name;
      if (date != null) updates['date'] = date.toIso8601String();
      if (startTime != null) updates['start_time'] = startTime;
      if (endTime != null) updates['end_time'] = endTime;
      if (classId != null) updates['class_id'] = classId;
      if (teacherId != null) updates['teacher_id'] = teacherId;
      if (studentIds != null) updates['student_ids'] = studentIds;
      if (location != null) updates['location'] = location;
      if (status != null) updates['status'] = status.name;
      if (notes != null) updates['notes'] = notes;

      final data = await supabase
          .from('sessions')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(Session.fromJson(data));
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String id) async {
    try {
      await supabase.from('sessions').delete().eq('id', id);
      return const Right(null);
    } catch (e, st) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
