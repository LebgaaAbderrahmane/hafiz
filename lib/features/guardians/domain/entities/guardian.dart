import 'package:freezed_annotation/freezed_annotation.dart';

part 'guardian.freezed.dart';
part 'guardian.g.dart';

/// Guardian entity.
///
/// Represents a parent/guardian of a student.
@freezed
abstract class Guardian with _$Guardian {
  const factory Guardian({
    required String id,
    required String organizationId,
    required String branchId,
    required String name,
    required String phone,
    String? email,
    String? address,
    String? occupation,
    GuardianType? type,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Guardian;

  factory Guardian.fromJson(Map<String, dynamic> json) =>
      _$GuardianFromJson(json);
}

/// Guardian type.
enum GuardianType {
  father,
  mother,
  brother,
  sister,
  uncle,
  aunt,
  grandfather,
  grandmother,
  other,
}

/// Extension for display names.
extension GuardianTypeExtension on GuardianType {
  String get displayNameAr {
    return switch (this) {
      GuardianType.father => 'الأب',
      GuardianType.mother => 'الأم',
      GuardianType.brother => 'الأخ',
      GuardianType.sister => 'الأخت',
      GuardianType.uncle => 'العم',
      GuardianType.aunt => 'العمة',
      GuardianType.grandfather => 'الجد',
      GuardianType.grandmother => 'الجدة',
      GuardianType.other => 'آخر',
    };
  }
}
