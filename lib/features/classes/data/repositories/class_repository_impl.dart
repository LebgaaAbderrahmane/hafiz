import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/exceptions.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/classes/domain/entities/school_class.dart';
import 'package:hafiz/features/classes/domain/repositories/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository {
  @override
  Future<Either<Failure, List<SchoolClass>>> getClasses({
    required String organizationId,
    String? branchId,
    ClassStatus? status,
    ClassLevel? level,
    String? teacherId,
    String? search,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      var query = supabase
          .from('classes')
          .select()
          .eq('organization_id', organizationId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (branchId != null) {
        query = query.eq('branch_id', branchId);
      }

      if (status != null) {
        query = query.eq('status', status.name);
      }

      if (level != null) {
        query = query.eq('level', level.name);
      }

      if (teacherId != null) {
        query = query.eq('teacher_id', teacherId);
      }

      if (search != null && search.isNotEmpty) {
        query = query.or('name.ilike.%$search%,description.ilike.%$search%');
      }

      final data = await query;
      final classes =
          data.map((json) => SchoolClass.fromJson(json)).toList();
      return Right(classes);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SchoolClass>> getClass(String id) async {
    try {
      final data =
          await supabase.from('classes').eq('id', id).select().single();
      return Right(SchoolClass.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SchoolClass>> createClass({
    required String organizationId,
    required String branchId,
    required String name,
    String? description,
    String? roomId,
    String? teacherId,
    required ClassLevel level,
    List<String>? daysOfWeek,
    String? startTime,
    String? endTime,
    int? maxCapacity,
  }) async {
    try {
      final data = await supabase
          .from('classes')
          .insert({
            'organization_id': organizationId,
            'branch_id': branchId,
            'name': name,
            'description': description,
            'room_id': roomId,
            'teacher_id': teacherId,
            'level': level.name,
            'days_of_week': daysOfWeek ?? [],
            'start_time': startTime,
            'end_time': endTime,
            'max_capacity': maxCapacity ?? 30,
          })
          .select()
          .single();
      return Right(SchoolClass.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, SchoolClass>> updateClass(
    String id, {
    String? name,
    String? description,
    String? roomId,
    String? teacherId,
    ClassLevel? level,
    List<String>? daysOfWeek,
    String? startTime,
    String? endTime,
    int? maxCapacity,
    ClassStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (roomId != null) updates['room_id'] = roomId;
      if (teacherId != null) updates['teacher_id'] = teacherId;
      if (level != null) updates['level'] = level.name;
      if (daysOfWeek != null) updates['days_of_week'] = daysOfWeek;
      if (startTime != null) updates['start_time'] = startTime;
      if (endTime != null) updates['end_time'] = endTime;
      if (maxCapacity != null) updates['max_capacity'] = maxCapacity;
      if (status != null) updates['status'] = status.name;
      if (startDate != null) {
        updates['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        updates['end_date'] = endDate.toIso8601String();
      }
      if (notes != null) updates['notes'] = notes;

      final data = await supabase
          .from('classes')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(SchoolClass.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClass(String id) async {
    try {
      await supabase.from('classes').delete().eq('id', id);
      return const Right(null);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<SchoolClass>>> searchClasses(
    String query, {
    required String organizationId,
    String? branchId,
  }) async {
    return getClasses(
      organizationId: organizationId,
      branchId: branchId,
      search: query,
    );
  }
}
