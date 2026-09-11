import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/exceptions.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/students/domain/entities/student.dart';
import 'package:hafiz/features/students/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  @override
  Future<Either<Failure, List<Student>>> getStudents({
    required String organizationId,
    String? branchId,
    StudentStatus? status,
    String? search,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      var query = supabase
          .from('students')
          .eq('organization_id', organizationId);

      if (branchId != null) {
        query = query.eq('branch_id', branchId);
      }
      if (status != null) {
        query = query.eq('status', status.name);
      }
      if (search != null && search.isNotEmpty) {
        query = query.or('full_name.ilike.%$search%,email.ilike.%$search%');
      }

      final data = await query
          .select()
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final students =
          data.map((json) => Student.fromJson(json)).toList();
      return Right(students);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Student>> getStudent(String id) async {
    try {
      final data =
          await supabase.from('students').eq('id', id).select().single();
      return Right(Student.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final data = await supabase
          .from('students')
          .insert({
            'organization_id': organizationId,
            'branch_id': branchId,
            'full_name': fullName,
            'student_id': studentId,
            'preferred_name': preferredName,
            'gender': gender?.name,
            'date_of_birth': dateOfBirth?.toIso8601String(),
            'nationality': nationality,
            'phone': phone,
            'email': email,
            'previous_quran_education': previousQuranEducation,
            'current_quran_level': currentQuranLevel,
          })
          .select()
          .single();
      return Right(Student.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updates['full_name'] = fullName;
      if (preferredName != null) updates['preferred_name'] = preferredName;
      if (gender != null) updates['gender'] = gender.name;
      if (dateOfBirth != null) {
        updates['date_of_birth'] = dateOfBirth.toIso8601String();
      }
      if (nationality != null) updates['nationality'] = nationality;
      if (phone != null) updates['phone'] = phone;
      if (email != null) updates['email'] = email;
      if (status != null) updates['status'] = status.name;
      if (previousQuranEducation != null) {
        updates['previous_quran_education'] = previousQuranEducation;
      }
      if (currentQuranLevel != null) {
        updates['current_quran_level'] = currentQuranLevel;
      }
      if (readingLevel != null) updates['reading_level'] = readingLevel;
      if (tajwidLevel != null) updates['tajwid_level'] = tajwidLevel;
      if (memorizationLevel != null) {
        updates['memorization_level'] = memorizationLevel;
      }

      final data = await supabase
          .from('students')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(Student.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(String id) async {
    try {
      await supabase.from('students').delete().eq('id', id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Student>>> searchStudents(
    String query, {
    required String organizationId,
    String? branchId,
  }) async {
    return getStudents(
      organizationId: organizationId,
      branchId: branchId,
      search: query,
    );
  }
}
