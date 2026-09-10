import 'package:freezed_annotation/freezed_annotation.dart';

part 'juz.freezed.dart';
part 'juz.g.dart';

/// Juz entity.
///
/// Represents a Juz (part) of the Qur'an.
@freezed
abstract class Juz with _$Juz {
  factory Juz({
    required int number,
    required String nameArabic,
    required String nameEnglish,
    required int startPage,
    required int endPage,
    required List<int> surahNumbers,
    required int totalAyahs,
  }) = _Juz;

  factory Juz.fromJson(Map<String, dynamic> json) => _$JuzFromJson(json);
}
