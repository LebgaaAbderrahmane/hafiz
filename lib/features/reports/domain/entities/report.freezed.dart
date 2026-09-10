// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('');

/// @nodoc
mixin _$Report {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get branchId => throw _privateConstructorUsedError;
  String get generatedById => throw _privateConstructorUsedError;
  ReportType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  Map<String, dynamic>? get parameters => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  ReportFormat? get format => throw _privateConstructorUsedError;
  String? get filePath => throw _privateConstructorUsedError;
  DateTime? get generatedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportCopyWith<Report> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCopyWith<$Res> {
  factory $ReportCopyWith(Report value, $Res Function(Report) then) =
      _$ReportCopyWithImpl<$Res, Report>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String generatedById,
    ReportType type,
    String title,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? data,
    ReportFormat? format,
    String? filePath,
    DateTime? generatedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ReportCopyWithImpl<$Res, $Val extends Report>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? generatedById = null,
    Object? type = null,
    Object? title = null,
    Object? parameters = freezed,
    Object? data = freezed,
    Object? format = freezed,
    Object? filePath = freezed,
    Object? generatedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      generatedById: null == generatedById
          ? _value.generatedById
          : generatedById as String,
      type: null == type ? _value.type : type as ReportType,
      title: null == title ? _value.title : title as String,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters as Map<String, dynamic>?,
      data: freezed == data ? _value.data : data as Map<String, dynamic>?,
      format: freezed == format ? _value.format : format as ReportFormat?,
      filePath: freezed == filePath ? _value.filePath : filePath as String?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt as DateTime?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportImplCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$$ReportImplCopyWith(
          _$ReportImpl value, $Res Function(_$ReportImpl) then) =
      __$$ReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String generatedById,
    ReportType type,
    String title,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? data,
    ReportFormat? format,
    String? filePath,
    DateTime? generatedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ReportImplCopyWithImpl<$Res>
    extends _$ReportCopyWithImpl<$Res, _$ReportImpl>
    implements _$$ReportImplCopyWith<$Res> {
  __$$ReportImplCopyWithImpl(
      _$ReportImpl _value, $Res Function(_$ReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? generatedById = null,
    Object? type = null,
    Object? title = null,
    Object? parameters = freezed,
    Object? data = freezed,
    Object? format = freezed,
    Object? filePath = freezed,
    Object? generatedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ReportImpl(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      generatedById: null == generatedById
          ? _value.generatedById
          : generatedById as String,
      type: null == type ? _value.type : type as ReportType,
      title: null == title ? _value.title : title as String,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters as Map<String, dynamic>?,
      data: freezed == data
          ? _value._data
          : data as Map<String, dynamic>?,
      format: freezed == format ? _value.format : format as ReportFormat?,
      filePath: freezed == filePath ? _value.filePath : filePath as String?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt as DateTime?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
    ));
  }
}

/// @nodoc
class _$ReportImpl implements _Report {
  const _$ReportImpl(
      {required this.id,
      required this.organizationId,
      required this.branchId,
      required this.generatedById,
      required this.type,
      required this.title,
      Map<String, dynamic>? parameters,
      Map<String, dynamic>? data,
      this.format,
      this.filePath,
      this.generatedAt,
      required this.createdAt})
      : _parameters = parameters,
        _data = data;

  @override
  String id;
  @override
  String organizationId;
  @override
  String branchId;
  @override
  String generatedById;
  @override
  ReportType type;
  @override
  String title;
  Map<String, dynamic>? _parameters;
  @override
  Map<String, dynamic>? get parameters {
    value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    return EqualUnmodifiableMapView(value);
  }

  Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    return EqualUnmodifiableMapView(value);
  }

  @override
  ReportFormat? format;
  @override
  String? filePath;
  @override
  DateTime? generatedAt;
  @override
  DateTime createdAt;

  @override
  String toString() {
    return 'Report(id: $id, organizationId: $organizationId, branchId: $branchId, generatedById: $generatedById, type: $type, title: $title, parameters: $parameters, data: $data, format: $format, filePath: $filePath, generatedAt: $generatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.generatedById, generatedById) ||
                other.generatedById == generatedById) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      branchId,
      generatedById,
      type,
      title,
      const DeepCollectionEquality().hash(_parameters),
      const DeepCollectionEquality().hash(_data),
      format,
      filePath,
      generatedAt,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      __$$ReportImplCopyWithImpl<_$ReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportImplToJson(this);
  }
}

abstract class _Report implements Report {
  const factory _Report(
      {required String id,
      required String organizationId,
      required String branchId,
      required String generatedById,
      required ReportType type,
      required String title,
      Map<String, dynamic>? parameters,
      Map<String, dynamic>? data,
      ReportFormat? format,
      String? filePath,
      DateTime? generatedAt,
      required DateTime createdAt}) = _$ReportImpl;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get branchId;
  @override
  String get generatedById;
  @override
  ReportType get type;
  @override
  String get title;
  @override
  Map<String, dynamic>? get parameters;
  @override
  Map<String, dynamic>? get data;
  @override
  ReportFormat? get format;
  @override
  String? get filePath;
  @override
  DateTime? get generatedAt;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
