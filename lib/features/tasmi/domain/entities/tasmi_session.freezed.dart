// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasmi_session.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('');

/// @nodoc
mixin _$TasmiSession {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get branchId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String? get classId => throw _privateConstructorUsedError;
  int get startSurah => throw _privateConstructorUsedError;
  int get startAyah => throw _privateConstructorUsedError;
  int get endSurah => throw _privateConstructorUsedError;
  int get endAyah => throw _privateConstructorUsedError;
  TasmiSessionType get sessionType => throw _privateConstructorUsedError;
  TasmiOutcome get outcome => throw _privateConstructorUsedError;
  int? get accuracyScore => throw _privateConstructorUsedError;
  int? get tajwidScore => throw _privateConstructorUsedError;
  int? get fluencyScore => throw _privateConstructorUsedError;
  int? get overallRating => throw _privateConstructorUsedError;
  List<TasmiError> get errors => throw _privateConstructorUsedError;
  String? get teacherNotes => throw _privateConstructorUsedError;
  DateTime get recordedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TasmiSessionCopyWith<TasmiSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasmiSessionCopyWith<$Res> {
  factory $TasmiSessionCopyWith(
          TasmiSession value, $Res Function(TasmiSession) then) =
      _$TasmiSessionCopyWithImpl<$Res, TasmiSession>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String studentId,
    String teacherId,
    String sessionId,
    String? classId,
    int startSurah,
    int startAyah,
    int endSurah,
    int endAyah,
    TasmiSessionType sessionType,
    TasmiOutcome outcome,
    int? accuracyScore,
    int? tajwidScore,
    int? fluencyScore,
    int? overallRating,
    List<TasmiError> errors,
    String? teacherNotes,
    DateTime recordedAt,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$TasmiSessionCopyWithImpl<$Res, $Val extends TasmiSession>
    implements $TasmiSessionCopyWith<$Res> {
  _$TasmiSessionCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? studentId = null,
    Object? teacherId = null,
    Object? sessionId = null,
    Object? classId = freezed,
    Object? startSurah = null,
    Object? startAyah = null,
    Object? endSurah = null,
    Object? endAyah = null,
    Object? sessionType = null,
    Object? outcome = null,
    Object? accuracyScore = freezed,
    Object? tajwidScore = freezed,
    Object? fluencyScore = freezed,
    Object? overallRating = freezed,
    Object? errors = null,
    Object? teacherNotes = freezed,
    Object? recordedAt = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      studentId: null == studentId ? _value.studentId : studentId as String,
      teacherId:
          null == teacherId ? _value.teacherId : teacherId as String,
      sessionId:
          null == sessionId ? _value.sessionId : sessionId as String,
      classId: freezed == classId ? _value.classId : classId as String?,
      startSurah: null == startSurah
          ? _value.startSurah
          : startSurah as int,
      startAyah:
          null == startAyah ? _value.startAyah : startAyah as int,
      endSurah: null == endSurah ? _value.endSurah : endSurah as int,
      endAyah: null == endAyah ? _value.endAyah : endAyah as int,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType as TasmiSessionType,
      outcome:
          null == outcome ? _value.outcome : outcome as TasmiOutcome,
      accuracyScore: freezed == accuracyScore
          ? _value.accuracyScore
          : accuracyScore as int?,
      tajwidScore: freezed == tajwidScore
          ? _value.tajwidScore
          : tajwidScore as int?,
      fluencyScore: freezed == fluencyScore
          ? _value.fluencyScore
          : fluencyScore as int?,
      overallRating: freezed == overallRating
          ? _value.overallRating
          : overallRating as int?,
      errors: null == errors
          ? _value.errors
          : errors as List<TasmiError>,
      teacherNotes: freezed == teacherNotes
          ? _value.teacherNotes
          : teacherNotes as String?,
      recordedAt:
          null == recordedAt ? _value.recordedAt : recordedAt as DateTime,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TasmiSessionImplCopyWith<$Res>
    implements $TasmiSessionCopyWith<$Res> {
  factory _$$TasmiSessionImplCopyWith(
          _$TasmiSessionImpl value, $Res Function(_$TasmiSessionImpl) then) =
      __$$TasmiSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String studentId,
    String teacherId,
    String sessionId,
    String? classId,
    int startSurah,
    int startAyah,
    int endSurah,
    int endAyah,
    TasmiSessionType sessionType,
    TasmiOutcome outcome,
    int? accuracyScore,
    int? tajwidScore,
    int? fluencyScore,
    int? overallRating,
    List<TasmiError> errors,
    String? teacherNotes,
    DateTime recordedAt,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$TasmiSessionImplCopyWithImpl<$Res>
    extends _$TasmiSessionCopyWithImpl<$Res, _$TasmiSessionImpl>
    implements _$$TasmiSessionImplCopyWith<$Res> {
  __$$TasmiSessionImplCopyWithImpl(
      _$TasmiSessionImpl _value, $Res Function(_$TasmiSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? studentId = null,
    Object? teacherId = null,
    Object? sessionId = null,
    Object? classId = freezed,
    Object? startSurah = null,
    Object? startAyah = null,
    Object? endSurah = null,
    Object? endAyah = null,
    Object? sessionType = null,
    Object? outcome = null,
    Object? accuracyScore = freezed,
    Object? tajwidScore = freezed,
    Object? fluencyScore = freezed,
    Object? overallRating = freezed,
    Object? errors = null,
    Object? teacherNotes = freezed,
    Object? recordedAt = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TasmiSessionImpl(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      studentId: null == studentId ? _value.studentId : studentId as String,
      teacherId:
          null == teacherId ? _value.teacherId : teacherId as String,
      sessionId:
          null == sessionId ? _value.sessionId : sessionId as String,
      classId: freezed == classId ? _value.classId : classId as String?,
      startSurah: null == startSurah
          ? _value.startSurah
          : startSurah as int,
      startAyah:
          null == startAyah ? _value.startAyah : startAyah as int,
      endSurah: null == endSurah ? _value.endSurah : endSurah as int,
      endAyah: null == endAyah ? _value.endAyah : endAyah as int,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType as TasmiSessionType,
      outcome:
          null == outcome ? _value.outcome : outcome as TasmiOutcome,
      accuracyScore: freezed == accuracyScore
          ? _value.accuracyScore
          : accuracyScore as int?,
      tajwidScore: freezed == tajwidScore
          ? _value.tajwidScore
          : tajwidScore as int?,
      fluencyScore: freezed == fluencyScore
          ? _value.fluencyScore
          : fluencyScore as int?,
      overallRating: freezed == overallRating
          ? _value.overallRating
          : overallRating as int?,
      errors: null == errors
          ? _value._errors
          : errors as List<TasmiError>,
      teacherNotes: freezed == teacherNotes
          ? _value.teacherNotes
          : teacherNotes as String?,
      recordedAt:
          null == recordedAt ? _value.recordedAt : recordedAt as DateTime,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ));
  }
}

/// @nodoc
class _$TasmiSessionImpl implements _TasmiSession {
  const _$TasmiSessionImpl(
      {required this.id,
      required this.organizationId,
      required this.branchId,
      required this.studentId,
      required this.teacherId,
      required this.sessionId,
      this.classId,
      required this.startSurah,
      required this.startAyah,
      required this.endSurah,
      required this.endAyah,
      required this.sessionType,
      required this.outcome,
      this.accuracyScore,
      this.tajwidScore,
      this.fluencyScore,
      this.overallRating,
      List<TasmiError> errors = const [],
      this.teacherNotes,
      required this.recordedAt,
      required this.createdAt,
      this.updatedAt})
      : _errors = errors;

  @override
  String id;
  @override
  String organizationId;
  @override
  String branchId;
  @override
  String studentId;
  @override
  String teacherId;
  @override
  String sessionId;
  @override
  String? classId;
  @override
  int startSurah;
  @override
  int startAyah;
  @override
  int endSurah;
  @override
  int endAyah;
  @override
  TasmiSessionType sessionType;
  @override
  TasmiOutcome outcome;
  @override
  int? accuracyScore;
  @override
  int? tajwidScore;
  @override
  int? fluencyScore;
  @override
  int? overallRating;
  List<TasmiError> _errors;
  @override
  List<TasmiError> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    return EqualUnmodifiableListView(_errors);
  }

  @override
  String? teacherNotes;
  @override
  DateTime recordedAt;
  @override
  DateTime createdAt;
  @override
  DateTime? updatedAt;

  @override
  String toString() {
    return 'TasmiSession(id: $id, organizationId: $organizationId, branchId: $branchId, studentId: $studentId, teacherId: $teacherId, sessionId: $sessionId, classId: $classId, startSurah: $startSurah, startAyah: $startAyah, endSurah: $endSurah, endAyah: $endAyah, sessionType: $sessionType, outcome: $outcome, accuracyScore: $accuracyScore, tajwidScore: $tajwidScore, fluencyScore: $fluencyScore, overallRating: $overallRating, errors: $errors, teacherNotes: $teacherNotes, recordedAt: $recordedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasmiSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.classId, classId) ||
                other.classId == classId) &&
            (identical(other.startSurah, startSurah) ||
                other.startSurah == startSurah) &&
            (identical(other.startAyah, startAyah) ||
                other.startAyah == startAyah) &&
            (identical(other.endSurah, endSurah) ||
                other.endSurah == endSurah) &&
            (identical(other.endAyah, endAyah) ||
                other.endAyah == endAyah) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.outcome, outcome) ||
                other.outcome == outcome) &&
            (identical(other.accuracyScore, accuracyScore) ||
                other.accuracyScore == accuracyScore) &&
            (identical(other.tajwidScore, tajwidScore) ||
                other.tajwidScore == tajwidScore) &&
            (identical(other.fluencyScore, fluencyScore) ||
                other.fluencyScore == fluencyScore) &&
            (identical(other.overallRating, overallRating) ||
                other.overallRating == overallRating) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.teacherNotes, teacherNotes) ||
                other.teacherNotes == teacherNotes) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        organizationId,
        branchId,
        studentId,
        teacherId,
        sessionId,
        classId,
        startSurah,
        startAyah,
        endSurah,
        endAyah,
        sessionType,
        outcome,
        accuracyScore,
        tajwidScore,
        fluencyScore,
        overallRating,
        const DeepCollectionEquality().hash(_errors),
        teacherNotes,
        recordedAt,
        createdAt,
        updatedAt,
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TasmiSessionImplCopyWith<_$TasmiSessionImpl> get copyWith =>
      __$$TasmiSessionImplCopyWithImpl<_$TasmiSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasmiSessionImplToJson(this);
  }
}

abstract class _TasmiSession implements TasmiSession {
  const factory _TasmiSession(
      {required String id,
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
      List<TasmiError> errors,
      String? teacherNotes,
      required DateTime recordedAt,
      required DateTime createdAt,
      DateTime? updatedAt}) = _$TasmiSessionImpl;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get branchId;
  @override
  String get studentId;
  @override
  String get teacherId;
  @override
  String get sessionId;
  @override
  String? get classId;
  @override
  int get startSurah;
  @override
  int get startAyah;
  @override
  int get endSurah;
  @override
  int get endAyah;
  @override
  TasmiSessionType get sessionType;
  @override
  TasmiOutcome get outcome;
  @override
  int? get accuracyScore;
  @override
  int? get tajwidScore;
  @override
  int? get fluencyScore;
  @override
  int? get overallRating;
  @override
  List<TasmiError> get errors;
  @override
  String? get teacherNotes;
  @override
  DateTime get recordedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TasmiSessionImplCopyWith<_$TasmiSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TasmiError {
  String get id => throw _privateConstructorUsedError;
  int get surahNumber => throw _privateConstructorUsedError;
  int get ayahNumber => throw _privateConstructorUsedError;
  String? get wordLocation => throw _privateConstructorUsedError;
  ErrorType get errorType => throw _privateConstructorUsedError;
  ErrorSeverity? get severity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TasmiErrorCopyWith<TasmiError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasmiErrorCopyWith<$Res> {
  factory $TasmiErrorCopyWith(
          TasmiError value, $Res Function(TasmiError) then) =
      _$TasmiErrorCopyWithImpl<$Res, TasmiError>;
  @useResult
  $Res call({
    String id,
    int surahNumber,
    int ayahNumber,
    String? wordLocation,
    ErrorType errorType,
    ErrorSeverity? severity,
    String? notes,
  });
}

/// @nodoc
class _$TasmiErrorCopyWithImpl<$Res, $Val extends TasmiError>
    implements $TasmiErrorCopyWith<$Res> {
  _$TasmiErrorCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? surahNumber = null,
    Object? ayahNumber = null,
    Object? wordLocation = freezed,
    Object? errorType = null,
    Object? severity = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      surahNumber:
          null == surahNumber ? _value.surahNumber : surahNumber as int,
      ayahNumber:
          null == ayahNumber ? _value.ayahNumber : ayahNumber as int,
      wordLocation: freezed == wordLocation
          ? _value.wordLocation
          : wordLocation as String?,
      errorType:
          null == errorType ? _value.errorType : errorType as ErrorType,
      severity:
          freezed == severity ? _value.severity : severity as ErrorSeverity?,
      notes: freezed == notes ? _value.notes : notes as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TasmiErrorImplCopyWith<$Res>
    implements $TasmiErrorCopyWith<$Res> {
  factory _$$TasmiErrorImplCopyWith(
          _$TasmiErrorImpl value, $Res Function(_$TasmiErrorImpl) then) =
      __$$TasmiErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int surahNumber,
    int ayahNumber,
    String? wordLocation,
    ErrorType errorType,
    ErrorSeverity? severity,
    String? notes,
  });
}

/// @nodoc
class __$$TasmiErrorImplCopyWithImpl<$Res>
    extends _$TasmiErrorCopyWithImpl<$Res, _$TasmiErrorImpl>
    implements _$$TasmiErrorImplCopyWith<$Res> {
  __$$TasmiErrorImplCopyWithImpl(
      _$TasmiErrorImpl _value, $Res Function(_$TasmiErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? surahNumber = null,
    Object? ayahNumber = null,
    Object? wordLocation = freezed,
    Object? errorType = null,
    Object? severity = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$TasmiErrorImpl(
      id: null == id ? _value.id : id as String,
      surahNumber:
          null == surahNumber ? _value.surahNumber : surahNumber as int,
      ayahNumber:
          null == ayahNumber ? _value.ayahNumber : ayahNumber as int,
      wordLocation: freezed == wordLocation
          ? _value.wordLocation
          : wordLocation as String?,
      errorType:
          null == errorType ? _value.errorType : errorType as ErrorType,
      severity:
          freezed == severity ? _value.severity : severity as ErrorSeverity?,
      notes: freezed == notes ? _value.notes : notes as String?,
    ));
  }
}

/// @nodoc
class _$TasmiErrorImpl implements _TasmiError {
  const _$TasmiErrorImpl(
      {required this.id,
      required this.surahNumber,
      required this.ayahNumber,
      this.wordLocation,
      required this.errorType,
      this.severity,
      this.notes});

  @override
  String id;
  @override
  int surahNumber;
  @override
  int ayahNumber;
  @override
  String? wordLocation;
  @override
  ErrorType errorType;
  @override
  ErrorSeverity? severity;
  @override
  String? notes;

  @override
  String toString() {
    return 'TasmiError(id: $id, surahNumber: $surahNumber, ayahNumber: $ayahNumber, wordLocation: $wordLocation, errorType: $errorType, severity: $severity, notes: $notes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasmiErrorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.surahNumber, surahNumber) ||
                other.surahNumber == surahNumber) &&
            (identical(other.ayahNumber, ayahNumber) ||
                other.ayahNumber == ayahNumber) &&
            (identical(other.wordLocation, wordLocation) ||
                other.wordLocation == wordLocation) &&
            (identical(other.errorType, errorType) ||
                other.errorType == errorType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, surahNumber, ayahNumber,
      wordLocation, errorType, severity, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TasmiErrorImplCopyWith<_$TasmiErrorImpl> get copyWith =>
      __$$TasmiErrorImplCopyWithImpl<_$TasmiErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasmiErrorImplToJson(this);
  }
}

abstract class _TasmiError implements TasmiError {
  const factory _TasmiError(
      {required String id,
      required int surahNumber,
      required int ayahNumber,
      String? wordLocation,
      required ErrorType errorType,
      ErrorSeverity? severity,
      String? notes}) = _$TasmiErrorImpl;

  @override
  String get id;
  @override
  int get surahNumber;
  @override
  int get ayahNumber;
  @override
  String? get wordLocation;
  @override
  ErrorType get errorType;
  @override
  ErrorSeverity? get severity;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$TasmiErrorImplCopyWith<_$TasmiErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
