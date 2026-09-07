import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/classes/domain/entities/school_class.dart';

abstract class ClassRepository {
  Future<Either<Failure, List<SchoolClass>>> getClasses({
    required String organizationId,
    String? branchId,
    ClassStatus? status,
    ClassLevel? level,
    String? teacherId,
    String? search,
    int limit = 50,
    int offset = 0,
  });

  Future<Either<Failure, SchoolClass>> getClass(String id);

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
  });

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
  });

  Future<Either<Failure, void>> deleteClass(String id);

  Future<Either<Failure, List<SchoolClass>>> searchClasses(
    String query, {
    required String organizationId,
    String? branchId,
  });
}
