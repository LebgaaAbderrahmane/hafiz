// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This is not allowed...',
);

/// @nodoc
mixin _$OrganizationUser {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  Role get role => throw _privateConstructorUsedError;
  String? get branchId => throw _privateConstructorUsedError;
  String? get branchName => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationUserCopyWith<OrganizationUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationUserCopyWith<$Res> {
  factory $OrganizationUserCopyWith(
          OrganizationUser value, $Res Function(OrganizationUser) then) =
      _$OrganizationUserCopyWithImpl<$Res, OrganizationUser>;
  @useResult
  $Res call({
    String id,
    String userId,
    String fullName,
    String? email,
    String? phone,
    Role role,
    String? branchId,
    String? branchName,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class _$OrganizationUserCopyWithImpl<$Res, $Val extends OrganizationUser>
    implements $OrganizationUserCopyWith<$Res> {
  _$OrganizationUserCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? branchId = freezed,
    Object? branchName = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      userId: null == userId ? _value.userId : userId as String,
      fullName: null == fullName ? _value.fullName : fullName as String,
      email: freezed == email ? _value.email : email as String?,
      phone: freezed == phone ? _value.phone : phone as String?,
      role: null == role ? _value.role : role as Role,
      branchId: freezed == branchId ? _value.branchId : branchId as String?,
      branchName:
          freezed == branchName ? _value.branchName : branchName as String?,
      isActive: null == isActive ? _value.isActive : isActive as bool,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationUserImplCopyWith<$Res>
    implements $OrganizationUserCopyWith<$Res> {
  factory _$$OrganizationUserImplCopyWith(
          _$OrganizationUserImpl value,
          $Res Function(_$OrganizationUserImpl) then) =
      __$$OrganizationUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String fullName,
    String? email,
    String? phone,
    Role role,
    String? branchId,
    String? branchName,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$OrganizationUserImplCopyWithImpl<$Res>
    extends _$OrganizationUserCopyWithImpl<$Res, _$OrganizationUserImpl>
    implements _$$OrganizationUserImplCopyWith<$Res> {
  __$$OrganizationUserImplCopyWithImpl(
      _$OrganizationUserImpl _value, $Res Function(_$OrganizationUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? branchId = freezed,
    Object? branchName = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_$OrganizationUserImpl(
      id: null == id ? _value.id : id as String,
      userId: null == userId ? _value.userId : userId as String,
      fullName: null == fullName ? _value.fullName : fullName as String,
      email: freezed == email ? _value.email : email as String?,
      phone: freezed == phone ? _value.phone : phone as String?,
      role: null == role ? _value.role : role as Role,
      branchId: freezed == branchId ? _value.branchId : branchId as String?,
      branchName:
          freezed == branchName ? _value.branchName : branchName as String?,
      isActive: null == isActive ? _value.isActive : isActive as bool,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
    ));
  }
}

/// @nodoc

class _$OrganizationUserImpl implements _OrganizationUser {
  _$OrganizationUserImpl({
    required this.id,
    required this.userId,
    required this.fullName,
    this.email,
    this.phone,
    required this.role,
    this.branchId,
    this.branchName,
    required this.isActive,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String userId;
  @override
  final String fullName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final Role role;
  @override
  final String? branchId;
  @override
  final String? branchName;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'OrganizationUser(id: $id, userId: $userId, fullName: $fullName, email: $email, phone: $phone, role: $role, branchId: $branchId, branchName: $branchName, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.branchName, branchName) ||
                other.branchName == branchName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, userId, fullName, email,
      phone, role, branchId, branchName, isActive, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationUserImplCopyWith<_$OrganizationUserImpl> get copyWith =>
      __$$OrganizationUserImplCopyWithImpl<_$OrganizationUserImpl>(
          this, _$identity);
}

abstract class _OrganizationUser implements OrganizationUser {
  factory _OrganizationUser({
    required String id,
    required String userId,
    required String fullName,
    String? email,
    String? phone,
    required Role role,
    String? branchId,
    String? branchName,
    required bool isActive,
    required DateTime createdAt,
  }) = _$OrganizationUserImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get fullName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  Role get role;
  @override
  String? get branchId;
  @override
  String? get branchName;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationUserImplCopyWith<_$OrganizationUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
