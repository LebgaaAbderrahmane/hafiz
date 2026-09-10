// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('');

/// @nodoc
mixin _$AppNotification {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get branchId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppNotificationCopyWith<AppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNotificationCopyWith<$Res> {
  factory $AppNotificationCopyWith(
          AppNotification value, $Res Function(AppNotification) then) =
      _$AppNotificationCopyWithImpl<$Res, AppNotification>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String userId,
    NotificationType type,
    String title,
    String body,
    Map<String, dynamic>? data,
    String? actionUrl,
    bool isRead,
    DateTime? readAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$AppNotificationCopyWithImpl<$Res, $Val extends AppNotification>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? data = freezed,
    Object? actionUrl = freezed,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      userId: null == userId ? _value.userId : userId as String,
      type: null == type ? _value.type : type as NotificationType,
      title: null == title ? _value.title : title as String,
      body: null == body ? _value.body : body as String,
      data: freezed == data ? _value.data : data as Map<String, dynamic>?,
      actionUrl:
          freezed == actionUrl ? _value.actionUrl : actionUrl as String?,
      isRead: null == isRead ? _value.isRead : isRead as bool,
      readAt: freezed == readAt ? _value.readAt : readAt as DateTime?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppNotificationImplCopyWith<$Res>
    implements $AppNotificationCopyWith<$Res> {
  factory _$$AppNotificationImplCopyWith(_$AppNotificationImpl value,
          $Res Function(_$AppNotificationImpl) then) =
      __$$AppNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String userId,
    NotificationType type,
    String title,
    String body,
    Map<String, dynamic>? data,
    String? actionUrl,
    bool isRead,
    DateTime? readAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$AppNotificationImplCopyWithImpl<$Res>
    extends _$AppNotificationCopyWithImpl<$Res, _$AppNotificationImpl>
    implements _$$AppNotificationImplCopyWith<$Res> {
  __$$AppNotificationImplCopyWithImpl(
      _$AppNotificationImpl _value, $Res Function(_$AppNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? data = freezed,
    Object? actionUrl = freezed,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$AppNotificationImpl(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      userId: null == userId ? _value.userId : userId as String,
      type: null == type ? _value.type : type as NotificationType,
      title: null == title ? _value.title : title as String,
      body: null == body ? _value.body : body as String,
      data: freezed == data
          ? _value._data
          : data as Map<String, dynamic>?,
      actionUrl:
          freezed == actionUrl ? _value.actionUrl : actionUrl as String?,
      isRead: null == isRead ? _value.isRead : isRead as bool,
      readAt: freezed == readAt ? _value.readAt : readAt as DateTime?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
    ));
  }
}

/// @nodoc
class _$AppNotificationImpl implements _AppNotification {
  _$AppNotificationImpl(
      {required this.id,
      required this.organizationId,
      required this.branchId,
      required this.userId,
      required this.type,
      required this.title,
      required this.body,
      Map<String, dynamic>? data,
      this.actionUrl,
      this.isRead = false,
      this.readAt,
      required this.createdAt})
      : _data = data;

  @override
  String id;
  @override
  String organizationId;
  @override
  String branchId;
  @override
  String userId;
  @override
  NotificationType type;
  @override
  String title;
  @override
  String body;
  Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    if (_data == null) return null;

    if (_data is EqualUnmodifiableMapView) return _data;

    return EqualUnmodifiableMapView(_data!);
  }

  @override
  String? actionUrl;
  @override
  @JsonKey()
  bool isRead;
  @override
  DateTime? readAt;
  @override
  DateTime createdAt;

  @override
  String toString() {
    return 'AppNotification(id: $id, organizationId: $organizationId, branchId: $branchId, userId: $userId, type: $type, title: $title, body: $body, data: $data, actionUrl: $actionUrl, isRead: $isRead, readAt: $readAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.userId, userId) ||
                other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.isRead, isRead) ||
                other.isRead == isRead) &&
            (identical(other.readAt, readAt) ||
                other.readAt == readAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      organizationId,
      branchId,
      userId,
      type,
      title,
      body,
      const DeepCollectionEquality().hash(_data),
      actionUrl,
      isRead,
      readAt,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      __$$AppNotificationImplCopyWithImpl<_$AppNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppNotificationImplToJson(this);
  }
}

abstract class _AppNotification implements AppNotification {
  factory _AppNotification(
      {required String id,
      required String organizationId,
      required String branchId,
      required String userId,
      required NotificationType type,
      required String title,
      required String body,
      Map<String, dynamic>? data,
      String? actionUrl,
      bool isRead,
      DateTime? readAt,
      required DateTime createdAt}) = _$AppNotificationImpl;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get branchId;
  @override
  String get userId;
  @override
  NotificationType get type;
  @override
  String get title;
  @override
  String get body;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get actionUrl;
  @override
  bool get isRead;
  @override
  DateTime? get readAt;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
