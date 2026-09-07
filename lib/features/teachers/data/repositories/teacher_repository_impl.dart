import 'package:dartz/dartz.dart';
import 'package:hafiz/core/errors/exceptions.dart';
import 'package:hafiz/core/errors/failures.dart';
import 'package:hafiz/core/network/supabase_client.dart';
import 'package:hafiz/features/teachers/domain/entities/teacher.dart';
import 'package:hafiz/features/teachers/domain/repositories/teacher_repository.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  @override
  Future<Either<Failure, List<Teacher>>> getTeachers({
    required String organizationId,
    String? branchId,
    TeacherStatus? status,
    String? search,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      var query = supabase
          .from('teachers')
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

      if (search != null && search.isNotEmpty) {
        query = query.or('full_name.ilike.%$search%,email.ilike.%$search%');
      }

      final data = await query;
      final teachers = data.map((json) => Teacher.fromJson(json)).toList();
      return Right(teachers);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Teacher>> getTeacher(String id) async {
    try {
      final data =
          await supabase.from('teachers').select().eq('id', id).single();
      return Right(Teacher.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
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
  }) async {
    try {
      final data = await supabase
          .from('teachers')
          .insert({
            'organization_id': organizationId,
            'branch_id': branchId,
            'user_id': userId,
            'employee_id': employeeId,
            'full_name': fullName,
            'preferred_name': preferredName,
            'gender': gender?.name,
            'date_of_birth': dateOfBirth?.toIso8601String(),
            'nationality': nationality,
            'phone': phone,
            'email': email,
            'specialization': specialization,
            'qualifications': qualifications ?? [],
            'certifications': certifications ?? [],
            'languages_spoken': languagesSpoken ?? [],
          })
          .select()
          .single();
      return Right(Teacher.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
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
      if (specialization != null) updates['specialization'] = specialization;
      if (qualifications != null) updates['qualifications'] = qualifications;
      if (certifications != null) updates['certifications'] = certifications;
      if (languagesSpoken != null) {
        updates['languages_spoken'] = languagesSpoken;
      }
      if (status != null) updates['status'] = status.name;
      if (notes != null) updates['notes'] = notes;

      final data = await supabase
          .from('teachers')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      return Right(Teacher.fromJson(data));
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeacher(String id) async {
    try {
      await supabase.from('teachers').delete().eq('id', id);
      return const Right(null);
    } on SupabaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Teacher>>> searchTeachers(
    String query, {
    required String organizationId,
    String? branchId,
  }) async {
    return getTeachers(
      organizationId: organizationId,
      branchId: branchId,
      search: query,
    );
  }
}
