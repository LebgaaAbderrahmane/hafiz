import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

@freezed
abstract class Organization with _$Organization {
  factory Organization({
    required String id,
    required String name,
    String? address,
    String? phone,
    String? email,
    String? logoUrl,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}
