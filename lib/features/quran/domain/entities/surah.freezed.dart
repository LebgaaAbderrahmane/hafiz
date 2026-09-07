// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('');

/// @nodoc
mixin _$Surah {
  int get number => throw _privateConstructorUsedError;
  String get nameArabic => throw _privateConstructorUsedError;
  String get nameEnglish => throw _privateConstructorUsedError;
  String get nameTransliteration => throw _privateConstructorUsedError;
  int get totalAyahs => throw _privateConstructorUsedError;
  RevelationType get revelationType => throw _privateConstructorUsedError;
  int get juz => throw _privateConstructorUsedError;
  int? get hizb => throw _privateConstructorUsedError;
  int? get page => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SurahCopyWith<Surah> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurahCopyWith<$Res> {
  factory $SurahCopyWith(Surah value, $Res Function(Surah) then) =
      _$SurahCopyWithImpl<$Res, Surah>;
  @useResult
  $Res call({
    int number,
    String nameArabic,
    String nameEnglish,
    String nameTransliteration,
    int totalAyahs,
    RevelationType revelationType,
    int juz,
    int? hizb,
    int? page,
    String? description,
  });
}

/// @nodoc
class _$SurahCopyWithImpl<$Res, $Val extends Surah>
    implements $SurahCopyWith<$Res> {
  _$SurahCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? nameArabic = null,
    Object? nameEnglish = null,
    Object? nameTransliteration = null,
    Object? totalAyahs = null,
    Object? revelationType = null,
    Object? juz = null,
    Object? hizb = freezed,
    Object? page = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      number: null == number ? _value.number : number as int,
      nameArabic:
          null == nameArabic ? _value.nameArabic : nameArabic as String,
      nameEnglish: null == nameEnglish
          ? _value.nameEnglish
          : nameEnglish as String,
      nameTransliteration: null == nameTransliteration
          ? _value.nameTransliteration
          : nameTransliteration as String,
      totalAyahs:
          null == totalAyahs ? _value.totalAyahs : totalAyahs as int,
      revelationType: null == revelationType
          ? _value.revelationType
          : revelationType as RevelationType,
      juz: null == juz ? _value.juz : juz as int,
      hizb: freezed == hizb ? _value.hizb : hizb as int?,
      page: freezed == page ? _value.page : page as int?,
      description:
          freezed == description ? _value.description : description as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SurahImplCopyWith<$Res> implements $SurahCopyWith<$Res> {
  factory _$$SurahImplCopyWith(
          _$SurahImpl value, $Res Function(_$SurahImpl) then) =
      __$$SurahImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int number,
    String nameArabic,
    String nameEnglish,
    String nameTransliteration,
    int totalAyahs,
    RevelationType revelationType,
    int juz,
    int? hizb,
    int? page,
    String? description,
  });
}

/// @nodoc
class __$$SurahImplCopyWithImpl<$Res>
    extends _$SurahCopyWithImpl<$Res, _$SurahImpl>
    implements _$$SurahImplCopyWith<$Res> {
  __$$SurahImplCopyWithImpl(
      _$SurahImpl _value, $Res Function(_$SurahImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? nameArabic = null,
    Object? nameEnglish = null,
    Object? nameTransliteration = null,
    Object? totalAyahs = null,
    Object? revelationType = null,
    Object? juz = null,
    Object? hizb = freezed,
    Object? page = freezed,
    Object? description = freezed,
  }) {
    return _then(_$SurahImpl(
      number: null == number ? _value.number : number as int,
      nameArabic:
          null == nameArabic ? _value.nameArabic : nameArabic as String,
      nameEnglish: null == nameEnglish
          ? _value.nameEnglish
          : nameEnglish as String,
      nameTransliteration: null == nameTransliteration
          ? _value.nameTransliteration
          : nameTransliteration as String,
      totalAyahs:
          null == totalAyahs ? _value.totalAyahs : totalAyahs as int,
      revelationType: null == revelationType
          ? _value.revelationType
          : revelationType as RevelationType,
      juz: null == juz ? _value.juz : juz as int,
      hizb: freezed == hizb ? _value.hizb : hizb as int?,
      page: freezed == page ? _value.page : page as int?,
      description:
          freezed == description ? _value.description : description as String?,
    ));
  }
}

/// @nodoc
class _$SurahImpl implements _Surah {
  const _$SurahImpl(
      {required this.number,
      required this.nameArabic,
      required this.nameEnglish,
      required this.nameTransliteration,
      required this.totalAyahs,
      required this.revelationType,
      required this.juz,
      this.hizb,
      this.page,
      this.description});

  @override
  final int number;
  @override
  final String nameArabic;
  @override
  final String nameEnglish;
  @override
  final String nameTransliteration;
  @override
  final int totalAyahs;
  @override
  final RevelationType revelationType;
  @override
  final int juz;
  @override
  final int? hizb;
  @override
  final int? page;
  @override
  final String? description;

  @override
  String toString() {
    return 'Surah(number: $number, nameArabic: $nameArabic, nameEnglish: $nameEnglish, nameTransliteration: $nameTransliteration, totalAyahs: $totalAyahs, revelationType: $revelationType, juz: $juz, hizb: $hizb, page: $page, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurahImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.nameArabic, nameArabic) ||
                other.nameArabic == nameArabic) &&
            (identical(other.nameEnglish, nameEnglish) ||
                other.nameEnglish == nameEnglish) &&
            (identical(other.nameTransliteration, nameTransliteration) ||
                other.nameTransliteration == nameTransliteration) &&
            (identical(other.totalAyahs, totalAyahs) ||
                other.totalAyahs == totalAyahs) &&
            (identical(other.revelationType, revelationType) ||
                other.revelationType == revelationType) &&
            (identical(other.juz, juz) || other.juz == juz) &&
            (identical(other.hizb, hizb) || other.hizb == hizb) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      number,
      nameArabic,
      nameEnglish,
      nameTransliteration,
      totalAyahs,
      revelationType,
      juz,
      hizb,
      page,
      description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SurahImplCopyWith<_$SurahImpl> get copyWith =>
      __$$SurahImplCopyWithImpl<_$SurahImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SurahImplToJson(this);
  }
}

abstract class _Surah implements Surah {
  const factory _Surah(
      {required final int number,
      required final String nameArabic,
      required final String nameEnglish,
      required final String nameTransliteration,
      required final int totalAyahs,
      required final RevelationType revelationType,
      required final int juz,
      final int? hizb,
      final int? page,
      final String? description}) = _$SurahImpl;

  @override
  int get number;
  @override
  String get nameArabic;
  @override
  String get nameEnglish;
  @override
  String get nameTransliteration;
  @override
  int get totalAyahs;
  @override
  RevelationType get revelationType;
  @override
  int get juz;
  @override
  int? get hizb;
  @override
  int? get page;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$SurahImplCopyWith<_$SurahImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
