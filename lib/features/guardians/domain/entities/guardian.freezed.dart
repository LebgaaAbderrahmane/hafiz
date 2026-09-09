// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guardian.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('');

/// @nodoc
mixin _$Guardian {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get branchId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get occupation => throw _privateConstructorUsedError;
  GuardianType? get type => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GuardianCopyWith<Guardian> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuardianCopyWith<$Res> {
  factory $GuardianCopyWith(Guardian value, $Res Function(Guardian) then) =
      _$GuardianCopyWithImpl<$Res, Guardian>;
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String name,
    String phone,
    String? email,
    String? address,
    String? occupation,
    GuardianType? type,
    String? notes,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$GuardianCopyWithImpl<$Res, $Val extends Guardian>
    implements $GuardianCopyWith<$Res> {
  _$GuardianCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? name = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
    Object? occupation = freezed,
    Object? type = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      name: null == name ? _value.name : name as String,
      phone: null == phone ? _value.phone : phone as String,
      email: freezed == email ? _value.email : email as String?,
      address: freezed == address ? _value.address : address as String?,
      occupation:
          freezed == occupation ? _value.occupation : occupation as String?,
      type: freezed == type ? _value.type : type as GuardianType?,
      notes: freezed == notes ? _value.notes : notes as String?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GuardianImplCopyWith<$Res>
    implements $GuardianCopyWith<$Res> {
  factory _$$GuardianImplCopyWith(
          _$GuardianImpl value, $Res Function(_$GuardianImpl) then) =
      __$$GuardianImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String organizationId,
    String branchId,
    String name,
    String phone,
    String? email,
    String? address,
    String? occupation,
    GuardianType? type,
    String? notes,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$GuardianImplCopyWithImpl<$Res>
    extends _$GuardianCopyWithImpl<$Res, _$GuardianImpl>
    implements _$$GuardianImplCopyWith<$Res> {
  __$$GuardianImplCopyWithImpl(
      _$GuardianImpl _value, $Res Function(_$GuardianImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? branchId = null,
    Object? name = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
    Object? occupation = freezed,
    Object? type = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$GuardianImpl(
      id: null == id ? _value.id : id as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId as String,
      branchId: null == branchId ? _value.branchId : branchId as String,
      name: null == name ? _value.name : name as String,
      phone: null == phone ? _value.phone : phone as String,
      email: freezed == email ? _value.email : email as String?,
      address: freezed == address ? _value.address : address as String?,
      occupation:
          freezed == occupation ? _value.occupation : occupation as String?,
      type: freezed == type ? _value.type : type as GuardianType?,
      notes: freezed == notes ? _value.notes : notes as String?,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          freezed == updatedAt ? _value.updatedAt : updatedAt as DateTime?,
    ));
  }
}

/// @nodoc
class _$GuardianImpl implements _Guardian {
  const _$GuardianImpl(
      {required this.id,
      required this.organizationId,
      required this.branchId,
      required this.name,
      required this.phone,
      this.email,
      this.address,
      this.occupation,
      this.type,
      this.notes,
      required this.createdAt,
      this.updatedAt});

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String branchId;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final String? occupation;
  @override
  final GuardianType? type;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Guardian(id: $id, organizationId: $organizationId, branchId: $branchId, name: $name, phone: $phone, email: $email, address: $address, occupation: $occupation, type: $type, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuardianImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) ||
                other.address == address) &&
            (identical(other.occupation, occupation) ||
                other.occupation == occupation) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
      name,
      phone,
      email,
      address,
      occupation,
      type,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GuardianImplCopyWith<_$GuardianImpl> get copyWith =>
      __$$GuardianImplCopyWithImpl<_$GuardianImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuardianImplToJson(this);
  }
}

abstract class _Guardian implements Guardian {
  const factory _Guardian(
      {required final String id,
      required final String organizationId,
      required final String branchId,
      required final String name,
      required final String phone,
      final String? email,
      final String? address,
      final String? occupation,
      final GuardianType? type,
      final String? notes,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$GuardianImpl;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get branchId;
  @override
  String get name;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  String? get occupation;
  @override
  GuardianType? get type;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$GuardianImplCopyWith<_$GuardianImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
