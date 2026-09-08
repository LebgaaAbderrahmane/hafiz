// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasmi_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TasmiSessionImpl _$$TasmiSessionImplFromJson(Map<String, dynamic> json) =>
    _$TasmiSessionImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      studentId: json['student_id'] as String,
      teacherId: json['teacher_id'] as String,
      sessionId: json['session_id'] as String,
      classId: json['class_id'] as String?,
      startSurah: (json['start_surah'] as num).toInt(),
      startAyah: (json['start_ayah'] as num).toInt(),
      endSurah: (json['end_surah'] as num).toInt(),
      endAyah: (json['end_ayah'] as num).toInt(),
      sessionType:
          $enumDecode(_$TasmiSessionTypeEnumMap, json['session_type']),
      outcome: $enumDecode(_$TasmiOutcomeEnumMap, json['outcome']),
      accuracyScore: (json['accuracy_score'] as num?)?.toInt(),
      tajwidScore: (json['tajwid_score'] as num?)?.toInt(),
      fluencyScore: (json['fluency_score'] as num?)?.toInt(),
      overallRating: (json['overall_rating'] as num?)?.toInt(),
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => TasmiError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      teacherNotes: json['teacher_notes'] as String?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TasmiSessionImplToJson(
        _$TasmiSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'student_id': instance.studentId,
      'teacher_id': instance.teacherId,
      'session_id': instance.sessionId,
      'class_id': instance.classId,
      'start_surah': instance.startSurah,
      'start_ayah': instance.startAyah,
      'end_surah': instance.endSurah,
      'end_ayah': instance.endAyah,
      'session_type': _$TasmiSessionTypeEnumMap[instance.sessionType]!,
      'outcome': _$TasmiOutcomeEnumMap[instance.outcome]!,
      'accuracy_score': instance.accuracyScore,
      'tajwid_score': instance.tajwidScore,
      'fluency_score': instance.fluencyScore,
      'overall_rating': instance.overallRating,
      'errors': instance.errors,
      'teacher_notes': instance.teacherNotes,
      'recorded_at': instance.recordedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TasmiSessionTypeEnumMap = {
  TasmiSessionType.newMemorization: 'new_memorization',
  TasmiSessionType.revision: 'revision',
  TasmiSessionType.comprehensiveRevision: 'comprehensive_revision',
  TasmiSessionType.exam: 'exam',
  TasmiSessionType.placement: 'placement',
  TasmiSessionType.competition: 'competition',
};

const _$TasmiOutcomeEnumMap = {
  TasmiOutcome.pass: 'pass',
  TasmiOutcome.needsRevision: 'needs_revision',
  TasmiOutcome.fail: 'fail',
};

_$TasmiErrorImpl _$$TasmiErrorImplFromJson(Map<String, dynamic> json) =>
    _$TasmiErrorImpl(
      id: json['id'] as String,
      surahNumber: (json['surah_number'] as num).toInt(),
      ayahNumber: (json['ayah_number'] as num).toInt(),
      wordLocation: json['word_location'] as String?,
      errorType: $enumDecode(_$ErrorTypeEnumMap, json['error_type']),
      severity: $enumDecodeNullable(_$ErrorSeverityEnumMap, json['severity']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TasmiErrorImplToJson(_$TasmiErrorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'surah_number': instance.surahNumber,
      'ayah_number': instance.ayahNumber,
      'word_location': instance.wordLocation,
      'error_type': _$ErrorTypeEnumMap[instance.errorType]!,
      'severity': _$ErrorSeverityEnumMap[instance.severity],
      'notes': instance.notes,
    };

const _$ErrorTypeEnumMap = {
  ErrorType.omission: 'omission',
  ErrorType.addition: 'addition',
  ErrorType.substitution: 'substitution',
  ErrorType.hesitation: 'hesitation',
  ErrorType.repeatedMistake: 'repeated_mistake',
  ErrorType.tajwidError: 'tajwid_error',
  ErrorType.pronunciationError: 'pronunciation_error',
  ErrorType.stoppingError: 'stopping_error',
  ErrorType.startingError: 'starting_error',
};

const _$ErrorSeverityEnumMap = {
  ErrorSeverity.minor: 'minor',
  ErrorSeverity.moderate: 'moderate',
  ErrorSeverity.major: 'major',
};
