import 'package:freezed_annotation/freezed_annotation.dart';

part 'surah.freezed.dart';
part 'surah.g.dart';

/// Surah entity.
///
/// Represents a Surah (chapter) of the Qur'an.
@freezed
abstract class Surah with _$Surah {
  factory Surah({
    required int number,
    required String nameArabic,
    required String nameEnglish,
    required String nameTransliteration,
    required int totalAyahs,
    required RevelationType revelationType,
    required int juz,
    int? hizb,
    int? page,
    String? description,
  }) = _Surah;

  factory Surah.fromJson(Map<String, dynamic> json) => _$SurahFromJson(json);
}

/// Revelation type (Meccan or Medinan).
enum RevelationType {
  meccan,
  medinan,
}

/// Extension for display names.
extension RevelationTypeExtension on RevelationType {
  String get displayName {
    return switch (this) {
      RevelationType.meccan => 'Meccan',
      RevelationType.medinan => 'Medinan',
    };
  }

  String get displayNameAr {
    return switch (this) {
      RevelationType.meccan => 'مكية',
      RevelationType.medinan => 'مدنية',
    };
  }
}
