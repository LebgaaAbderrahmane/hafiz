// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('');

/// @nodoc
mixin _$Attendance {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get branchId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get classId => throw _privateConstructorUsedError;
  AttendanceStatus get status => throw _privateConstructorUsedError;
  String? get checkInTime => throw _privateConstructorUsedError;
  String? get checkOutTime => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get markedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttendanceCopyWith<Attendance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceCopyWith<$Res> {
  factory $AttendanceCopyWith(
          Attendance value, $Res Function(Attendance) then) =
      _$AttendanceCopyWithImpl<$Res, Attendance>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String studentId,
    String sessionId,
    String classId,
    AttendanceStatus status,
    String? checkInTime,
    String? checkOutTime,
    String? notes,
    String? markedBy,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$AttendanceCopyWithImpl<$Res, $Val extends Attendance>
    implements $AttendanceCopyWith<$Res> {
  _$AttendanceCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? studentId = null,
    Object? sessionId = null,
    Object? classId = null,
    Object? status = null,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? notes = freezed,
    Object? markedBy = freezed,
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
      sessionId:
          null == sessionId ? _value.sessionId : sessionId as String,
      classId: null == classId ? _value.classId : classId as String,
      status: null == status ? _value.status : status as AttendanceStatus,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime as String?,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime as String?,
      notes: freezed == notes ? _value.notes : notes as String?,
      markedBy: freezed == markedBy ? _value.markedBy : markedBy as String?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceImplCopyWith<$Res>
    implements $AttendanceCopyWith<$Res> {
  factory _$$AttendanceImplCopyWith(
          _$AttendanceImpl value, $Res Function(_$AttendanceImpl) then) =
      __$$AttendanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String studentId,
    String sessionId,
    String classId,
    AttendanceStatus status,
    String? checkInTime,
    String? checkOutTime,
    String? notes,
    String? markedBy,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$AttendanceImplCopyWithImpl<$Res>
    extends _$AttendanceCopyWithImpl<$Res, _$AttendanceImpl>
    implements _$$AttendanceImplCopyWith<$Res> {
  __$$AttendanceImplCopyWithImpl(
      _$AttendanceImpl _value, $Res Function(_$AttendanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? studentId = null,
    Object? sessionId = null,
    Object? classId = null,
    Object? status = null,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? notes = freezed,
    Object? markedBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AttendanceImpl(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      studentId: null == studentId ? _value.studentId : studentId as String,
      sessionId:
          null == sessionId ? _value.sessionId : sessionId as String,
      classId: null == classId ? _value.classId : classId as String,
      status: null == status ? _value.status : status as AttendanceStatus,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime as String?,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime as String?,
      notes: freezed == notes ? _value.notes : notes as String?,
      markedBy: freezed == markedBy ? _value.markedBy : markedBy as String?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ));
  }
}

/// @nodoc
class _$AttendanceImpl implements _Attendance {
  const _$AttendanceImpl(
      {required this.id,
      required this.organizationId,
      required this.branchId,
      required this.studentId,
      required this.sessionId,
      required this.classId,
      required this.status,
      this.checkInTime,
      this.checkOutTime,
      this.notes,
      this.markedBy,
      required this.createdAt,
      this.updatedAt});

  @override
  String id;
  @override
  String organizationId;
  @override
  String branchId;
  @override
  String studentId;
  @override
  String sessionId;
  @override
  String classId;
  @override
  AttendanceStatus status;
  @override
  String? checkInTime;
  @override
  String? checkOutTime;
  @override
  String? notes;
  @override
  String? markedBy;
  @override
  DateTime createdAt;
  @override
  DateTime? updatedAt;

  @override
  String toString() {
    return 'Attendance(id: $id, organizationId: $organizationId, branchId: $branchId, studentId: $studentId, sessionId: $sessionId, classId: $classId, status: $status, checkInTime: $checkInTime, checkOutTime: $checkOutTime, notes: $notes, markedBy: $markedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.classId, classId) ||
                other.classId == classId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.markedBy, markedBy) ||
                other.markedBy == markedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      branchId,
      studentId,
      sessionId,
      classId,
      status,
      checkInTime,
      checkOutTime,
      notes,
      markedBy,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceImplCopyWith<_$AttendanceImpl> get copyWith =>
      __$$AttendanceImplCopyWithImpl<_$AttendanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceImplToJson(this);
  }
}

abstract class _Attendance implements Attendance {
  const factory _Attendance(
      {required String id,
      required String organizationId,
      required String branchId,
      required String studentId,
      required String sessionId,
      required String classId,
      required AttendanceStatus status,
      String? checkInTime,
      String? checkOutTime,
      String? notes,
      String? markedBy,
      required DateTime createdAt,
      DateTime? updatedAt}) = _$AttendanceImpl;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get branchId;
  @override
  String get studentId;
  @override
  String get sessionId;
  @override
  String get classId;
  @override
  AttendanceStatus get status;
  @override
  String? get checkInTime;
  @override
  String? get checkOutTime;
  @override
  String? get notes;
  @override
  String? get markedBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AttendanceImplCopyWith<_$AttendanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
