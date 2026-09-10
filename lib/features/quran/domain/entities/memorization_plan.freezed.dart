// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorization_plan.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('');

/// @nodoc
mixin _$MemorizationPlan {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String? get classId => throw _privateConstructorUsedError;
  MemorizationStatus get status => throw _privateConstructorUsedError;
  MemorizationPriority get priority => throw _privateConstructorUsedError;
  int get currentSurah => throw _privateConstructorUsedError;
  int get currentAyah => throw _privateConstructorUsedError;
  int get targetSurah => throw _privateConstructorUsedError;
  int get targetAyah => throw _privateConstructorUsedError;
  List<MemorizationCheckpoint> get checkpoints =>
      throw _privateConstructorUsedError;
  List<MemorizationSession> get sessions => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemorizationPlanCopyWith<MemorizationPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemorizationPlanCopyWith<$Res> {
  factory $MemorizationPlanCopyWith(
          MemorizationPlan value, $Res Function(MemorizationPlan) then) =
      _$MemorizationPlanCopyWithImpl<$Res, MemorizationPlan>;
  @useResult
  $Res call({
    String id,
    String studentId,
    String teacherId,
    String organizationId,
    String? classId,
    MemorizationStatus status,
    MemorizationPriority priority,
    int currentSurah,
    int currentAyah,
    int targetSurah,
    int targetAyah,
    List<MemorizationCheckpoint> checkpoints,
    List<MemorizationSession> sessions,
    String? notes,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$MemorizationPlanCopyWithImpl<$Res, $Val extends MemorizationPlan>
    implements $MemorizationPlanCopyWith<$Res> {
  _$MemorizationPlanCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? teacherId = null,
    Object? organizationId = null,
    Object? classId = freezed,
    Object? status = null,
    Object? priority = null,
    Object? currentSurah = null,
    Object? currentAyah = null,
    Object? targetSurah = null,
    Object? targetAyah = null,
    Object? checkpoints = null,
    Object? sessions = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      studentId: null == studentId ? _value.studentId : studentId as String,
      teacherId: null == teacherId ? _value.teacherId : teacherId as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      classId: freezed == classId ? _value.classId : classId as String?,
      status: null == status ? _value.status : status as MemorizationStatus,
      priority:
          null == priority ? _value.priority : priority as MemorizationPriority,
      currentSurah: null == currentSurah
          ? _value.currentSurah
          : currentSurah as int,
      currentAyah: null == currentAyah
          ? _value.currentAyah
          : currentAyah as int,
      targetSurah: null == targetSurah
          ? _value.targetSurah
          : targetSurah as int,
      targetAyah:
          null == targetAyah ? _value.targetAyah : targetAyah as int,
      checkpoints: null == checkpoints
          ? _value.checkpoints
          : checkpoints as List<MemorizationCheckpoint>,
      sessions: null == sessions
          ? _value.sessions
          : sessions as List<MemorizationSession>,
      notes: freezed == notes ? _value.notes : notes as String?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemorizationPlanImplCopyWith<$Res>
    implements $MemorizationPlanCopyWith<$Res> {
  factory _$$MemorizationPlanImplCopyWith(
          _$MemorizationPlanImpl value,
          $Res Function(_$MemorizationPlanImpl) then) =
      __$$MemorizationPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    String teacherId,
    String organizationId,
    String? classId,
    MemorizationStatus status,
    MemorizationPriority priority,
    int currentSurah,
    int currentAyah,
    int targetSurah,
    int targetAyah,
    List<MemorizationCheckpoint> checkpoints,
    List<MemorizationSession> sessions,
    String? notes,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$MemorizationPlanImplCopyWithImpl<$Res>
    extends _$MemorizationPlanCopyWithImpl<$Res, _$MemorizationPlanImpl>
    implements _$$MemorizationPlanImplCopyWith<$Res> {
  __$$MemorizationPlanImplCopyWithImpl(
      _$MemorizationPlanImpl _value, $Res Function(_$MemorizationPlanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? teacherId = null,
    Object? organizationId = null,
    Object? classId = freezed,
    Object? status = null,
    Object? priority = null,
    Object? currentSurah = null,
    Object? currentAyah = null,
    Object? targetSurah = null,
    Object? targetAyah = null,
    Object? checkpoints = null,
    Object? sessions = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$MemorizationPlanImpl(
      id: null == id ? _value.id : id as String,
      studentId: null == studentId ? _value.studentId : studentId as String,
      teacherId: null == teacherId ? _value.teacherId : teacherId as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      classId: freezed == classId ? _value.classId : classId as String?,
      status: null == status ? _value.status : status as MemorizationStatus,
      priority:
          null == priority ? _value.priority : priority as MemorizationPriority,
      currentSurah: null == currentSurah
          ? _value.currentSurah
          : currentSurah as int,
      currentAyah: null == currentAyah
          ? _value.currentAyah
          : currentAyah as int,
      targetSurah: null == targetSurah
          ? _value.targetSurah
          : targetSurah as int,
      targetAyah:
          null == targetAyah ? _value.targetAyah : targetAyah as int,
      checkpoints: null == checkpoints
          ? _value._checkpoints
          : checkpoints as List<MemorizationCheckpoint>,
      sessions: null == sessions
          ? _value._sessions
          : sessions as List<MemorizationSession>,
      notes: freezed == notes ? _value.notes : notes as String?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt as DateTime?,
    ));
  }
}

/// @nodoc
class _$MemorizationPlanImpl implements _MemorizationPlan {
  const _$MemorizationPlanImpl(
      {required this.id,
      required this.studentId,
      required this.teacherId,
      required this.organizationId,
      this.classId,
      required this.status,
      required this.priority,
      required this.currentSurah,
      required this.currentAyah,
      required this.targetSurah,
      required this.targetAyah,
      List<MemorizationCheckpoint> checkpoints = const [],
      List<MemorizationSession> sessions = const [],
      this.notes,
      required this.createdAt,
      this.updatedAt,
      this.completedAt})
      : _checkpoints = checkpoints,
        _sessions = sessions;

  @override
  String id;
  @override
  String studentId;
  @override
  String teacherId;
  @override
  String organizationId;
  @override
  String? classId;
  @override
  MemorizationStatus status;
  @override
  MemorizationPriority priority;
  @override
  int currentSurah;
  @override
  int currentAyah;
  @override
  int targetSurah;
  @override
  int targetAyah;
  List<MemorizationCheckpoint> _checkpoints;
  @override
  List<MemorizationCheckpoint> get checkpoints {
    if (_checkpoints is EqualUnmodifiableListView) return _checkpoints;
    return EqualUnmodifiableListView(_checkpoints);
  }

  List<MemorizationSession> _sessions;
  @override
  List<MemorizationSession> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  String? notes;
  @override
  DateTime createdAt;
  @override
  DateTime? updatedAt;
  @override
  DateTime? completedAt;

  @override
  String toString() {
    return 'MemorizationPlan(id: $id, studentId: $studentId, teacherId: $teacherId, organizationId: $organizationId, classId: $classId, status: $status, priority: $priority, currentSurah: $currentSurah, currentAyah: $currentAyah, targetSurah: $targetSurah, targetAyah: $targetAyah, checkpoints: $checkpoints, sessions: $sessions, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemorizationPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.classId, classId) ||
                other.classId == classId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.currentSurah, currentSurah) ||
                other.currentSurah == currentSurah) &&
            (identical(other.currentAyah, currentAyah) ||
                other.currentAyah == currentAyah) &&
            (identical(other.targetSurah, targetSurah) ||
                other.targetSurah == targetSurah) &&
            (identical(other.targetAyah, targetAyah) ||
                other.targetAyah == targetAyah) &&
            const DeepCollectionEquality()
                .equals(other._checkpoints, _checkpoints) &&
            const DeepCollectionEquality()
                .equals(other._sessions, _sessions) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      teacherId,
      organizationId,
      classId,
      status,
      priority,
      currentSurah,
      currentAyah,
      targetSurah,
      targetAyah,
      const DeepCollectionEquality().hash(_checkpoints),
      const DeepCollectionEquality().hash(_sessions),
      notes,
      createdAt,
      updatedAt,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemorizationPlanImplCopyWith<_$MemorizationPlanImpl> get copyWith =>
      __$$MemorizationPlanImplCopyWithImpl<_$MemorizationPlanImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemorizationPlanImplToJson(this);
  }
}

abstract class _MemorizationPlan implements MemorizationPlan {
  const factory _MemorizationPlan(
      {required String id,
      required String studentId,
      required String teacherId,
      required String organizationId,
      String? classId,
      required MemorizationStatus status,
      required MemorizationPriority priority,
      required int currentSurah,
      required int currentAyah,
      required int targetSurah,
      required int targetAyah,
      List<MemorizationCheckpoint> checkpoints,
      List<MemorizationSession> sessions,
      String? notes,
      required DateTime createdAt,
      DateTime? updatedAt,
      DateTime? completedAt}) = _$MemorizationPlanImpl;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String get teacherId;
  @override
  String get organizationId;
  @override
  String? get classId;
  @override
  MemorizationStatus get status;
  @override
  MemorizationPriority get priority;
  @override
  int get currentSurah;
  @override
  int get currentAyah;
  @override
  int get targetSurah;
  @override
  int get targetAyah;
  @override
  List<MemorizationCheckpoint> get checkpoints;
  @override
  List<MemorizationSession> get sessions;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$MemorizationPlanImplCopyWith<_$MemorizationPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MemorizationCheckpoint {
  String get id => throw _privateConstructorUsedError;
  int get surahNumber => throw _privateConstructorUsedError;
  int get startAyah => throw _privateConstructorUsedError;
  int get endAyah => throw _privateConstructorUsedError;
  CheckpointStatus get status => throw _privateConstructorUsedError;
  int? get qualityScore => throw _privateConstructorUsedError;
  String? get teacherNotes => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemorizationCheckpointCopyWith<MemorizationCheckpoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemorizationCheckpointCopyWith<$Res> {
  factory $MemorizationCheckpointCopyWith(MemorizationCheckpoint value,
          $Res Function(MemorizationCheckpoint) then) =
      _$MemorizationCheckpointCopyWithImpl<$Res, MemorizationCheckpoint>;
  @useResult
  $Res call({
    String id,
    int surahNumber,
    int startAyah,
    int endAyah,
    CheckpointStatus status,
    int? qualityScore,
    String? teacherNotes,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$MemorizationCheckpointCopyWithImpl<$Res,
        $Val extends MemorizationCheckpoint>
    implements $MemorizationCheckpointCopyWith<$Res> {
  _$MemorizationCheckpointCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? surahNumber = null,
    Object? startAyah = null,
    Object? endAyah = null,
    Object? status = null,
    Object? qualityScore = freezed,
    Object? teacherNotes = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      surahNumber:
          null == surahNumber ? _value.surahNumber : surahNumber as int,
      startAyah:
          null == startAyah ? _value.startAyah : startAyah as int,
      endAyah: null == endAyah ? _value.endAyah : endAyah as int,
      status: null == status ? _value.status : status as CheckpointStatus,
      qualityScore: freezed == qualityScore
          ? _value.qualityScore
          : qualityScore as int?,
      teacherNotes: freezed == teacherNotes
          ? _value.teacherNotes
          : teacherNotes as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemorizationCheckpointImplCopyWith<$Res>
    implements $MemorizationCheckpointCopyWith<$Res> {
  factory _$$MemorizationCheckpointImplCopyWith(
          _$MemorizationCheckpointImpl value,
          $Res Function(_$MemorizationCheckpointImpl) then) =
      __$$MemorizationCheckpointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int surahNumber,
    int startAyah,
    int endAyah,
    CheckpointStatus status,
    int? qualityScore,
    String? teacherNotes,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$MemorizationCheckpointImplCopyWithImpl<$Res>
    extends _$MemorizationCheckpointCopyWithImpl<$Res,
        _$MemorizationCheckpointImpl>
    implements _$$MemorizationCheckpointImplCopyWith<$Res> {
  __$$MemorizationCheckpointImplCopyWithImpl(
      _$MemorizationCheckpointImpl _value,
      $Res Function(_$MemorizationCheckpointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? surahNumber = null,
    Object? startAyah = null,
    Object? endAyah = null,
    Object? status = null,
    Object? qualityScore = freezed,
    Object? teacherNotes = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$MemorizationCheckpointImpl(
      id: null == id ? _value.id : id as String,
      surahNumber:
          null == surahNumber ? _value.surahNumber : surahNumber as int,
      startAyah:
          null == startAyah ? _value.startAyah : startAyah as int,
      endAyah: null == endAyah ? _value.endAyah : endAyah as int,
      status: null == status ? _value.status : status as CheckpointStatus,
      qualityScore: freezed == qualityScore
          ? _value.qualityScore
          : qualityScore as int?,
      teacherNotes: freezed == teacherNotes
          ? _value.teacherNotes
          : teacherNotes as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt as DateTime?,
    ));
  }
}

/// @nodoc
class _$MemorizationCheckpointImpl implements _MemorizationCheckpoint {
  const _$MemorizationCheckpointImpl(
      {required this.id,
      required this.surahNumber,
      required this.startAyah,
      required this.endAyah,
      required this.status,
      this.qualityScore,
      this.teacherNotes,
      this.completedAt});

  @override
  String id;
  @override
  int surahNumber;
  @override
  int startAyah;
  @override
  int endAyah;
  @override
  CheckpointStatus status;
  @override
  int? qualityScore;
  @override
  String? teacherNotes;
  @override
  DateTime? completedAt;

  @override
  String toString() {
    return 'MemorizationCheckpoint(id: $id, surahNumber: $surahNumber, startAyah: $startAyah, endAyah: $endAyah, status: $status, qualityScore: $qualityScore, teacherNotes: $teacherNotes, completedAt: $completedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemorizationCheckpointImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.surahNumber, surahNumber) ||
                other.surahNumber == surahNumber) &&
            (identical(other.startAyah, startAyah) ||
                other.startAyah == startAyah) &&
            (identical(other.endAyah, endAyah) ||
                other.endAyah == endAyah) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            (identical(other.teacherNotes, teacherNotes) ||
                other.teacherNotes == teacherNotes) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, surahNumber, startAyah,
      endAyah, status, qualityScore, teacherNotes, completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemorizationCheckpointImplCopyWith<_$MemorizationCheckpointImpl>
      get copyWith => __$$MemorizationCheckpointImplCopyWithImpl<
          _$MemorizationCheckpointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemorizationCheckpointImplToJson(this);
  }
}

abstract class _MemorizationCheckpoint implements MemorizationCheckpoint {
  const factory _MemorizationCheckpoint(
      {required String id,
      required int surahNumber,
      required int startAyah,
      required int endAyah,
      required CheckpointStatus status,
      int? qualityScore,
      String? teacherNotes,
      DateTime? completedAt}) = _$MemorizationCheckpointImpl;

  @override
  String get id;
  @override
  int get surahNumber;
  @override
  int get startAyah;
  @override
  int get endAyah;
  @override
  CheckpointStatus get status;
  @override
  int? get qualityScore;
  @override
  String? get teacherNotes;
  @override
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$MemorizationCheckpointImplCopyWith<_$MemorizationCheckpointImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MemorizationSession {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  String get fromSurah => throw _privateConstructorUsedError;
  int get fromAyah => throw _privateConstructorUsedError;
  String get toSurah => throw _privateConstructorUsedError;
  int get toAyah => throw _privateConstructorUsedError;
  int? get qualityScore => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemorizationSessionCopyWith<MemorizationSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemorizationSessionCopyWith<$Res> {
  factory $MemorizationSessionCopyWith(
          MemorizationSession value, $Res Function(MemorizationSession) then) =
      _$MemorizationSessionCopyWithImpl<$Res, MemorizationSession>;
  @useResult
  $Res call({
    String id,
    DateTime date,
    int durationMinutes,
    String fromSurah,
    int fromAyah,
    String toSurah,
    int toAyah,
    int? qualityScore,
    String? notes,
  });
}

/// @nodoc
class _$MemorizationSessionCopyWithImpl<$Res, $Val extends MemorizationSession>
    implements $MemorizationSessionCopyWith<$Res> {
  _$MemorizationSessionCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? durationMinutes = null,
    Object? fromSurah = null,
    Object? fromAyah = null,
    Object? toSurah = null,
    Object? toAyah = null,
    Object? qualityScore = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      date: null == date ? _value.date : date as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes as int,
      fromSurah:
          null == fromSurah ? _value.fromSurah : fromSurah as String,
      fromAyah: null == fromAyah ? _value.fromAyah : fromAyah as int,
      toSurah: null == toSurah ? _value.toSurah : toSurah as String,
      toAyah: null == toAyah ? _value.toAyah : toAyah as int,
      qualityScore: freezed == qualityScore
          ? _value.qualityScore
          : qualityScore as int?,
      notes: freezed == notes ? _value.notes : notes as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemorizationSessionImplCopyWith<$Res>
    implements $MemorizationSessionCopyWith<$Res> {
  factory _$$MemorizationSessionImplCopyWith(
          _$MemorizationSessionImpl value,
          $Res Function(_$MemorizationSessionImpl) then) =
      __$$MemorizationSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime date,
    int durationMinutes,
    String fromSurah,
    int fromAyah,
    String toSurah,
    int toAyah,
    int? qualityScore,
    String? notes,
  });
}

/// @nodoc
class __$$MemorizationSessionImplCopyWithImpl<$Res>
    extends _$MemorizationSessionCopyWithImpl<$Res, _$MemorizationSessionImpl>
    implements _$$MemorizationSessionImplCopyWith<$Res> {
  __$$MemorizationSessionImplCopyWithImpl(
      _$MemorizationSessionImpl _value,
      $Res Function(_$MemorizationSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? durationMinutes = null,
    Object? fromSurah = null,
    Object? fromAyah = null,
    Object? toSurah = null,
    Object? toAyah = null,
    Object? qualityScore = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$MemorizationSessionImpl(
      id: null == id ? _value.id : id as String,
      date: null == date ? _value.date : date as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes as int,
      fromSurah:
          null == fromSurah ? _value.fromSurah : fromSurah as String,
      fromAyah: null == fromAyah ? _value.fromAyah : fromAyah as int,
      toSurah: null == toSurah ? _value.toSurah : toSurah as String,
      toAyah: null == toAyah ? _value.toAyah : toAyah as int,
      qualityScore: freezed == qualityScore
          ? _value.qualityScore
          : qualityScore as int?,
      notes: freezed == notes ? _value.notes : notes as String?,
    ));
  }
}

/// @nodoc
class _$MemorizationSessionImpl implements _MemorizationSession {
  const _$MemorizationSessionImpl(
      {required this.id,
      required this.date,
      required this.durationMinutes,
      required this.fromSurah,
      required this.fromAyah,
      required this.toSurah,
      required this.toAyah,
      this.qualityScore,
      this.notes});

  @override
  String id;
  @override
  DateTime date;
  @override
  int durationMinutes;
  @override
  String fromSurah;
  @override
  int fromAyah;
  @override
  String toSurah;
  @override
  int toAyah;
  @override
  int? qualityScore;
  @override
  String? notes;

  @override
  String toString() {
    return 'MemorizationSession(id: $id, date: $date, durationMinutes: $durationMinutes, fromSurah: $fromSurah, fromAyah: $fromAyah, toSurah: $toSurah, toAyah: $toAyah, qualityScore: $qualityScore, notes: $notes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemorizationSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.fromSurah, fromSurah) ||
                other.fromSurah == fromSurah) &&
            (identical(other.fromAyah, fromAyah) ||
                other.fromAyah == fromAyah) &&
            (identical(other.toSurah, toSurah) ||
                other.toSurah == toSurah) &&
            (identical(other.toAyah, toAyah) || other.toAyah == toAyah) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, date, durationMinutes,
      fromSurah, fromAyah, toSurah, toAyah, qualityScore, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemorizationSessionImplCopyWith<_$MemorizationSessionImpl> get copyWith =>
      __$$MemorizationSessionImplCopyWithImpl<_$MemorizationSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemorizationSessionImplToJson(this);
  }
}

abstract class _MemorizationSession implements MemorizationSession {
  const factory _MemorizationSession(
      {required String id,
      required DateTime date,
      required int durationMinutes,
      required String fromSurah,
      required int fromAyah,
      required String toSurah,
      required int toAyah,
      int? qualityScore,
      String? notes}) = _$MemorizationSessionImpl;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  int get durationMinutes;
  @override
  String get fromSurah;
  @override
  int get fromAyah;
  @override
  String get toSurah;
  @override
  int get toAyah;
  @override
  int? get qualityScore;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$MemorizationSessionImplCopyWith<_$MemorizationSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
