// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This is not allowed...',
);

/// @nodoc
mixin _$Organization {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrganizationCopyWith<Organization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationCopyWith<$Res> {
  factory $OrganizationCopyWith(
          Organization value, $Res Function(Organization) then) =
      _$OrganizationCopyWithImpl<$Res, Organization>;
  @useResult
  $Res call({
    String id,
    String name,
    String? address,
    String? phone,
    String? email,
    String? logoUrl,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$OrganizationCopyWithImpl<$Res, $Val extends Organization>
    implements $OrganizationCopyWith<$Res> {
  _$OrganizationCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? logoUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      name: null == name ? _value.name : name as String,
      address: freezed == address ? _value.address : address as String?,
      phone: freezed == phone ? _value.phone : phone as String?,
      email: freezed == email ? _value.email : email as String?,
      logoUrl: freezed == logoUrl ? _value.logoUrl : logoUrl as String?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationImplCopyWith<$Res>
    implements $OrganizationCopyWith<$Res> {
  factory _$$OrganizationImplCopyWith(
          _$OrganizationImpl value, $Res Function(_$OrganizationImpl) then) =
      __$$OrganizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? address,
    String? phone,
    String? email,
    String? logoUrl,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$OrganizationImplCopyWithImpl<$Res>
    extends _$OrganizationCopyWithImpl<$Res, _$OrganizationImpl>
    implements _$$OrganizationImplCopyWith<$Res> {
  __$$OrganizationImplCopyWithImpl(
      _$OrganizationImpl _value, $Res Function(_$OrganizationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? logoUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OrganizationImpl(
      id: null == id ? _value.id : id as String,
      name: null == name ? _value.name : name as String,
      address: freezed == address ? _value.address : address as String?,
      phone: freezed == phone ? _value.phone : phone as String?,
      email: freezed == email ? _value.email : email as String?,
      logoUrl: freezed == logoUrl ? _value.logoUrl : logoUrl as String?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ));
  }
}

/// @nodoc

class _$OrganizationImpl implements _Organization {
  _$OrganizationImpl({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.logoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? logoUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Organization(id: $id, name: $name, address: $address, phone: $phone, email: $email, logoUrl: $logoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) ||
                other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.logoUrl, logoUrl) ||
                other.logoUrl == logoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, address, phone, email, logoUrl, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationImplCopyWith<_$OrganizationImpl> get copyWith =>
      __$$OrganizationImplCopyWithImpl<_$OrganizationImpl>(this, _$identity);
}

abstract class _Organization implements Organization {
  factory _Organization({
    required String id,
    required String name,
    String? address,
    String? phone,
    String? email,
    String? logoUrl,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _$OrganizationImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get address;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get logoUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationImplCopyWith<_$OrganizationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
