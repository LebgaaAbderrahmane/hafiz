import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/features/students/domain/entities/student.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<Student>>> getStudents({
    required String organizationId,
    String? branchId,
    StudentStatus? status,
    String? search,
    int limit = 50,
    int offset = 0,
  });

  Future<Either<Failure, Student>> getStudent(String id);

  Future<Either<Failure, Student>> createStudent({
    required String organizationId,
    required String branchId,
    required String fullName,
    String? studentId,
    String? preferredName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? nationality,
    String? phone,
    String? email,
    String? previousQuranEducation,
    String? currentQuranLevel,
  });

  Future<Either<Failure, Student>> updateStudent(
    String id, {
    String? fullName,
    String? preferredName,
    Gender? gender,
    DateTime? dateOfBirth,
    String? nationality,
    String? phone,
    String? email,
    StudentStatus? status,
    String? previousQuranEducation,
    String? currentQuranLevel,
    String? readingLevel,
    String? tajwidLevel,
    String? memorizationLevel,
  });

  Future<Either<Failure, void>> deleteStudent(String id);

  Future<Either<Failure, List<Student>>> searchStudents(
    String query, {
    required String organizationId,
    String? branchId,
  });
}
