/// Qur'an utility functions.
///
/// Helper functions for working with Qur'an data.
class QuranUtils {
  QuranUtils._();

  /// Number of surahs in the Qur'an.
  static const int totalSurahs = 114;

  /// Number of juz.
  static const int totalJuz = 30;

  /// Number of hizb.
  static const int totalHizb = 60;

  /// Number of rub.
  static const int totalRub = 240;

  /// Total ayahs in the Qur'an.
  static const int totalAyahs = 6236;

  /// Calculate progress percentage from memorized ayahs.
  static double calculateProgress(int memorizedAyahs) {
    if (memorizedAyahs <= 0) return 0;
    if (memorizedAyahs >= totalAyahs) return 100;
    return (memorizedAyahs / totalAyahs) * 100;
  }

  /// Convert ayah count to juz (approximate).
  static double ayahsToJuz(int ayahs) {
    return ayahs / (totalAyahs / totalJuz);
  }

  /// Convert ayah count to pages (approximate, ~20 ayahs per page).
  static int ayahsToPages(int ayahs) {
    return (ayahs / 20).ceil();
  }

  /// Format passage range as readable string.
  /// Example: "Al-Baqarah 1-20" or "البقرة ١-٢٠"
  static String formatPassageRange({
    required int startSurah,
    required int startAyah,
    required int endSurah,
    required int endAyah,
    bool arabic = true,
  }) {
    if (startSurah == endSurah) {
      if (arabic) {
        return '$startSurah:$startAyah-$endAyah';
      }
      return 'Surah $startSurah: $startAyah-$endAyah';
    }
    if (arabic) {
      return '$startSurah:$startAyah - $endSurah:$endAyah';
    }
    return 'Surah $startSurah:$startAyah - Surah $endSurah:$endAyah';
  }

  /// Calculate estimated ayahs in a passage range.
  /// This is approximate — real data should come from the database.
  static int estimateAyahs({
    required int startSurah,
    required int startAyah,
    required int endSurah,
    required int endAyah,
  }) {
    if (startSurah == endSurah) {
      return endAyah - startAyah + 1;
    }
    // Rough estimate: ~110 ayahs per surah average
    final surahDiff = endSurah - startSurah;
    return (surahDiff * 110) + endAyah - startAyah + 1;
  }
}
