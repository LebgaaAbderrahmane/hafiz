import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/teachers/domain/entities/teacher.dart';

abstract class TeacherRepository {
  Future<Either<Failure, List<Teacher>>> getTeachers({
    required String organizationId,
    String? branchId,
    TeacherStatus? status,
    String? search,
    int limit = 50,
    int offset = 0,
  });

  Future<Either<Failure, Teacher>> getTeacher(String id);

  Future<Either<Failure, Teacher>> createTeacher({
    required String organizationId,
    required String branchId,
    required String userId,
    required String fullName,
    String? employeeId,
    String? preferredName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? nationality,
    String? phone,
    String? email,
    String? specialization,
    List<String>? qualifications,
    List<String>? certifications,
    List<String>? languagesSpoken,
  });

  Future<Either<Failure, Teacher>> updateTeacher(
    String id, {
    String? fullName,
    String? preferredName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? nationality,
    String? phone,
    String? email,
    String? specialization,
    List<String>? qualifications,
    List<String>? certifications,
    List<String>? languagesSpoken,
    TeacherStatus? status,
    String? notes,
  });

  Future<Either<Failure, void>> deleteTeacher(String id);

  Future<Either<Failure, List<Teacher>>> searchTeachers(
    String query, {
    required String organizationId,
    String? branchId,
  });
}
