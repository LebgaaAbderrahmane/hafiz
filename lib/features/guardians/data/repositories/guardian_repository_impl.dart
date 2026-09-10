import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/guardians/domain/entities/guardian.dart';
import 'package:hafiz/features/guardians/domain/repositories/guardian_repository.dart';

class GuardianRepositoryImpl implements GuardianRepository {
  final SupabaseClient _client;

  GuardianRepositoryImpl(this._client);

  SupabaseClient get _supabase => _client;

  @override
  Future<List<Guardian>> getBranchGuardians({
    required String branchId,
    String? search,
  }) async {
    var query = _supabase
        .from('guardians')
        .select()
        .eq('branch_id', branchId);

    if (search != null && search.isNotEmpty) {
      query = query.or('name.ilike.%$search%,phone.ilike.%$search%');
    }

    final data = await query.order('name');
    return (data as List).map((json) => Guardian.fromJson(json)).toList();
  }

  @override
  Future<List<Guardian>> getStudentGuardians(String studentId) async {
    final data = await _supabase
        .from('student_guardians')
        .select('guardians(*)')
        .eq('student_id', studentId);

    return (data as List)
        .map((json) => Guardian.fromJson(json['guardians']))
        .toList();
  }

  @override
  Future<Guardian?> getGuardianById(String guardianId) async {
    final data = await _supabase
        .from('guardians')
        .select()
        .eq('id', guardianId)
        .maybeSingle();
    return data != null ? Guardian.fromJson(data) : null;
  }

  @override
  Future<Guardian> createGuardian(Guardian guardian) async {
    final data = await _supabase
        .from('guardians')
        .insert(guardian.toJson())
        .select()
        .single();
    return Guardian.fromJson(data);
  }

  @override
  Future<Guardian> updateGuardian(Guardian guardian) async {
    final data = await _supabase
        .from('guardians')
        .update(guardian.toJson())
        .eq('id', guardian.id)
        .select()
        .single();
    return Guardian.fromJson(data);
  }

  @override
  Future<void> deleteGuardian(String guardianId) async {
    await _supabase.from('guardians').delete().eq('id', guardianId);
  }

  @override
  Future<void> linkGuardianToStudent({
    required String guardianId,
    required String studentId,
    required String relationship,
  }) async {
    await _supabase.from('student_guardians').insert({
      'guardian_id': guardianId,
      'student_id': studentId,
      'relationship': relationship,
    });
  }

  @override
  Future<void> unlinkGuardianFromStudent({
    required String guardianId,
    required String studentId,
  }) async {
    await _supabase.from('student_guardians').delete().match({
      'guardian_id': guardianId,
      'student_id': studentId,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getStudentGuardianRelationships(
      String studentId) async {
    final data = await _supabase
        .from('student_guardians')
        .select()
        .eq('student_id', studentId);
    return (data as List).cast<Map<String, dynamic>>();
  }
}
