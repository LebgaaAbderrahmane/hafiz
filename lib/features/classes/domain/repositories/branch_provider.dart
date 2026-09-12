import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';

/// Simple branch model (not freezed — avoids build_runner).
class Branch {
  final String id;
  final String organizationId;
  final String name;
  final String? address;
  final String? phone;

  const Branch({
    required this.id,
    required this.organizationId,
    required this.name,
    this.address,
    this.phone,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json['id'] as String,
        organizationId: json['organization_id'] as String,
        name: json['name'] as String,
        address: json['address'] as String?,
        phone: json['phone'] as String?,
      );
}

/// Branches for the current organization.
final orgBranchesProvider =
    FutureProvider.autoDispose<List<Branch>>((ref) async {
  final orgId = ref.watch(activeOrganizationIdProvider);
  if (orgId == null) return [];

  final response = await Supabase.instance.client
      .from('branches')
      .select()
      .eq('organization_id', orgId)
      .order('name');

  return (response as List).map((json) => Branch.fromJson(json)).toList();
});
