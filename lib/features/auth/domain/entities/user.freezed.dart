// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This is not allowed...',
);

/// @nodoc
mixin _$AppUser {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get preferredName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppUserCopyWith<AppUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call({
    String id,
    String email,
    String? phone,
    String fullName,
    String? preferredName,
    String? avatarUrl,
    String language,
    bool isActive,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? phone = freezed,
    Object? fullName = null,
    Object? preferredName = freezed,
    Object? avatarUrl = freezed,
    Object? language = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      email: null == email ? _value.email : email as String,
      phone: freezed == phone ? _value.phone : phone as String?,
      fullName: null == fullName ? _value.fullName : fullName as String,
      preferredName: freezed == preferredName
          ? _value.preferredName
          : preferredName as String?,
      avatarUrl:
          freezed == avatarUrl ? _value.avatarUrl : avatarUrl as String?,
      language: null == language ? _value.language : language as String,
      isActive: null == isActive ? _value.isActive : isActive as bool,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res>
    implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
          _$AppUserImpl value, $Res Function(_$AppUserImpl) then) =
      __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String? phone,
    String fullName,
    String? preferredName,
    String? avatarUrl,
    String language,
    bool isActive,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
      _$AppUserImpl _value, $Res Function(_$AppUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? phone = freezed,
    Object? fullName = null,
    Object? preferredName = freezed,
    Object? avatarUrl = freezed,
    Object? language = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AppUserImpl(
      id: null == id ? _value.id : id as String,
      email: null == email ? _value.email : email as String,
      phone: freezed == phone ? _value.phone : phone as String?,
      fullName: null == fullName ? _value.fullName : fullName as String,
      preferredName: freezed == preferredName
          ? _value.preferredName
          : preferredName as String?,
      avatarUrl:
          freezed == avatarUrl ? _value.avatarUrl : avatarUrl as String?,
      language: null == language ? _value.language : language as String,
      isActive: null == isActive ? _value.isActive : isActive as bool,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ));
  }
}

/// @nodoc

class _$AppUserImpl implements _AppUser {
  _$AppUserImpl({
    required this.id,
    required this.email,
    this.phone,
    required this.fullName,
    this.preferredName,
    this.avatarUrl,
    this.language = 'ar',
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  String id;
  @override
  String email;
  @override
  String? phone;
  @override
  String fullName;
  @override
  String? preferredName;
  @override
  String? avatarUrl;
  @override
  @JsonKey()
  String language;
  @override
  @JsonKey()
  bool isActive;
  @override
  DateTime createdAt;
  @override
  DateTime? updatedAt;

  @override
  String toString() {
    return 'AppUser(id: $id, email: $email, phone: $phone, fullName: $fullName, preferredName: $preferredName, avatarUrl: $avatarUrl, language: $language, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.preferredName, preferredName) ||
                other.preferredName == preferredName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, email, phone, fullName,
      preferredName, avatarUrl, language, isActive, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);
}

abstract class _AppUser implements AppUser {
  factory _AppUser({
    required String id,
    required String email,
    String? phone,
    required String fullName,
    String? preferredName,
    String? avatarUrl,
    String language,
    bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _$AppUserImpl;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get phone;
  @override
  String get fullName;
  @override
  String? get preferredName;
  @override
  String? get avatarUrl;
  @override
  String get language;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserRole {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String? get branchId => throw _privateConstructorUsedError;
  Role get role => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserRoleCopyWith<UserRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRoleCopyWith<$Res> {
  factory $UserRoleCopyWith(UserRole value, $Res Function(UserRole) then) =
      _$UserRoleCopyWithImpl<$Res, UserRole>;
  @useResult
  $Res call({
    String id,
    String userId,
    String organizationId,
    String? branchId,
    Role role,
    DateTime createdAt,
  });
}

/// @nodoc
class _$UserRoleCopyWithImpl<$Res, $Val extends UserRole>
    implements $UserRoleCopyWith<$Res> {
  _$UserRoleCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? organizationId = null,
    Object? branchId = freezed,
    Object? role = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      userId: null == userId ? _value.userId : userId as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: freezed == branchId ? _value.branchId : branchId as String?,
      role: null == role ? _value.role : role as Role,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRoleImplCopyWith<$Res>
    implements $UserRoleCopyWith<$Res> {
  factory _$$UserRoleImplCopyWith(
          _$UserRoleImpl value, $Res Function(_$UserRoleImpl) then) =
      __$$UserRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String organizationId,
    String? branchId,
    Role role,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$UserRoleImplCopyWithImpl<$Res>
    extends _$UserRoleCopyWithImpl<$Res, _$UserRoleImpl>
    implements _$$UserRoleImplCopyWith<$Res> {
  __$$UserRoleImplCopyWithImpl(
      _$UserRoleImpl _value, $Res Function(_$UserRoleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? organizationId = null,
    Object? branchId = freezed,
    Object? role = null,
    Object? createdAt = null,
  }) {
    return _then(_$UserRoleImpl(
      id: null == id ? _value.id : id as String,
      userId: null == userId ? _value.userId : userId as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: freezed == branchId ? _value.branchId : branchId as String?,
      role: null == role ? _value.role : role as Role,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
    ));
  }
}

/// @nodoc

class _$UserRoleImpl implements _UserRole {
  _$UserRoleImpl({
    required this.id,
    required this.userId,
    required this.organizationId,
    this.branchId,
    required this.role,
    required this.createdAt,
  });

  @override
  String id;
  @override
  String userId;
  @override
  String organizationId;
  @override
  String? branchId;
  @override
  Role role;
  @override
  DateTime createdAt;

  @override
  String toString() {
    return 'UserRole(id: $id, userId: $userId, organizationId: $organizationId, branchId: $branchId, role: $role, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRoleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, organizationId, branchId, role, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRoleImplCopyWith<_$UserRoleImpl> get copyWith =>
      __$$UserRoleImplCopyWithImpl<_$UserRoleImpl>(this, _$identity);
}

abstract class _UserRole implements UserRole {
  factory _UserRole({
    required String id,
    required String userId,
    required String organizationId,
    String? branchId,
    required Role role,
    required DateTime createdAt,
  }) = _$UserRoleImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get organizationId;
  @override
  String? get branchId;
  @override
  Role get role;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserRoleImplCopyWith<_$UserRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
