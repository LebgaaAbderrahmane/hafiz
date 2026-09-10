import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasmi_session.freezed.dart';
part 'tasmi_session.g.dart';

/// TasmiSession entity.
///
/// Records the result of an in-person tasmi' session.
/// Teacher listens to student reciting, then records the evaluation.
@freezed
abstract class TasmiSession with _$TasmiSession {
  factory TasmiSession({
    required String id,
    required String organizationId,
    required String branchId,
    required String studentId,
    required String teacherId,
    required String sessionId,
    String? classId,
    required int startSurah,
    required int startAyah,
    required int endSurah,
    required int endAyah,
    required TasmiSessionType sessionType,
    required TasmiOutcome outcome,
    int? accuracyScore,
    int? tajwidScore,
    int? fluencyScore,
    int? overallRating,
    @Default([]) List<TasmiError> errors,
    String? teacherNotes,
    required DateTime recordedAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TasmiSession;

  factory TasmiSession.fromJson(Map<String, dynamic> json) =>
      _$TasmiSessionFromJson(json);
}

/// Tasmi error.
@freezed
abstract class TasmiError with _$TasmiError {
  factory TasmiError({
    required String id,
    required int surahNumber,
    required int ayahNumber,
    String? wordLocation,
    required ErrorType errorType,
    ErrorSeverity? severity,
    String? notes,
  }) = _TasmiError;

  factory TasmiError.fromJson(Map<String, dynamic> json) =>
      _$TasmiErrorFromJson(json);
}

/// Session type.
enum TasmiSessionType {
  newMemorization,
  revision,
  comprehensiveRevision,
  exam,
  placement,
  competition,
}

/// Outcome.
enum TasmiOutcome {
  pass,
  needsRevision,
  fail,
}

/// Error type.
enum ErrorType {
  omission,
  addition,
  substitution,
  hesitation,
  repeatedMistake,
  tajwidError,
  pronunciationError,
  stoppingError,
  startingError,
}

/// Error severity.
enum ErrorSeverity {
  minor,
  moderate,
  major,
}

/// Extension for display names.
extension TasmiSessionTypeExtension on TasmiSessionType {
  String get displayName {
    return switch (this) {
      TasmiSessionType.newMemorization => 'New Memorization',
      TasmiSessionType.revision => 'Revision',
      TasmiSessionType.comprehensiveRevision => 'Comprehensive Revision',
      TasmiSessionType.exam => 'Exam',
      TasmiSessionType.placement => 'Placement',
      TasmiSessionType.competition => 'Competition',
    };
  }

  String get displayNameAr {
    return switch (this) {
      TasmiSessionType.newMemorization => 'حفظ جديد',
      TasmiSessionType.revision => 'مراجعة',
      TasmiSessionType.comprehensiveRevision => 'مراجعة شاملة',
      TasmiSessionType.exam => 'امتحان',
      TasmiSessionType.placement => 'تحصيب',
      TasmiSessionType.competition => 'مسابقة',
    };
  }
}

extension TasmiOutcomeExtension on TasmiOutcome {
  String get displayName {
    return switch (this) {
      TasmiOutcome.pass => 'Pass',
      TasmiOutcome.needsRevision => 'Needs Revision',
      TasmiOutcome.fail => 'Fail',
    };
  }

  String get displayNameAr {
    return switch (this) {
      TasmiOutcome.pass => 'نجح',
      NeedsRevision => 'يحتاج مراجعة',
      TasmiOutcome.fail => 'لم ينجح',
    };
  }

  int get colorValue {
    return switch (this) {
      TasmiOutcome.pass => 0xFF2D9D78,
      TasmiOutcome.needsRevision => 0xFFD4A843,
      TasmiOutcome.fail => 0xFFD44343,
    };
  }
}

extension ErrorTypeExtension on ErrorType {
  String get displayNameAr {
    return switch (this) {
      ErrorType.omission => 'حذف',
      ErrorType.addition => 'إضافة',
      ErrorType.substitution => 'تبديل',
      ErrorType.hesitation => 'تتردد',
      ErrorType.repeatedMistake => 'خطأ متكرر',
      ErrorType.tajwidError => 'خطأ تجويد',
      ErrorType.pronunciationError => 'خطأ نطق',
      ErrorType.stoppingError => 'خطأ إيقاف',
      ErrorType.startingError => 'خطأ بدء',
    };
  }
}
