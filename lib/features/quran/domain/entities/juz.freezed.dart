// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('');

/// @nodoc
mixin _$Juz {
  int get number => throw _privateConstructorUsedError;
  String get nameArabic => throw _privateConstructorUsedError;
  String get nameEnglish => throw _privateConstructorUsedError;
  int get startPage => throw _privateConstructorUsedError;
  int get endPage => throw _privateConstructorUsedError;
  List<int> get surahNumbers => throw _privateConstructorUsedError;
  int get totalAyahs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JuzCopyWith<Juz> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JuzCopyWith<$Res> {
  factory $JuzCopyWith(Juz value, $Res Function(Juz) then) =
      _$JuzCopyWithImpl<$Res, Juz>;
  @useResult
  $Res call({
    int number,
    String nameArabic,
    String nameEnglish,
    int startPage,
    int endPage,
    List<int> surahNumbers,
    int totalAyahs,
  });
}

/// @nodoc
class _$JuzCopyWithImpl<$Res, $Val extends Juz>
    implements $JuzCopyWith<$Res> {
  _$JuzCopyWithImpl(this._value, this._then);

  $Val _value;
  $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? nameArabic = null,
    Object? nameEnglish = null,
    Object? startPage = null,
    Object? endPage = null,
    Object? surahNumbers = null,
    Object? totalAyahs = null,
  }) {
    return _then(_value.copyWith(
      number: null == number ? _value.number : number as int,
      nameArabic:
          null == nameArabic ? _value.nameArabic : nameArabic as String,
      nameEnglish: null == nameEnglish
          ? _value.nameEnglish
          : nameEnglish as String,
      startPage: null == startPage ? _value.startPage : startPage as int,
      endPage: null == endPage ? _value.endPage : endPage as int,
      surahNumbers: null == surahNumbers
          ? _value.surahNumbers
          : surahNumbers as List<int>,
      totalAyahs:
          null == totalAyahs ? _value.totalAyahs : totalAyahs as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JuzImplCopyWith<$Res> implements $JuzCopyWith<$Res> {
  factory _$$JuzImplCopyWith(
          _$JuzImpl value, $Res Function(_$JuzImpl) then) =
      __$$JuzImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int number,
    String nameArabic,
    String nameEnglish,
    int startPage,
    int endPage,
    List<int> surahNumbers,
    int totalAyahs,
  });
}

/// @nodoc
class __$$JuzImplCopyWithImpl<$Res>
    extends _$JuzCopyWithImpl<$Res, _$JuzImpl>
    implements _$$JuzImplCopyWith<$Res> {
  __$$JuzImplCopyWithImpl(
      _$JuzImpl _value, $Res Function(_$JuzImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? nameArabic = null,
    Object? nameEnglish = null,
    Object? startPage = null,
    Object? endPage = null,
    Object? surahNumbers = null,
    Object? totalAyahs = null,
  }) {
    return _then(_$JuzImpl(
      number: null == number ? _value.number : number as int,
      nameArabic:
          null == nameArabic ? _value.nameArabic : nameArabic as String,
      nameEnglish: null == nameEnglish
          ? _value.nameEnglish
          : nameEnglish as String,
      startPage: null == startPage ? _value.startPage : startPage as int,
      endPage: null == endPage ? _value.endPage : endPage as int,
      surahNumbers: null == surahNumbers
          ? _value._surahNumbers
          : surahNumbers as List<int>,
      totalAyahs:
          null == totalAyahs ? _value.totalAyahs : totalAyahs as int,
    ));
  }
}

/// @nodoc
class _$JuzImpl implements _Juz {
  const _$JuzImpl(
      {required this.number,
      required this.nameArabic,
      required this.nameEnglish,
      required this.startPage,
      required this.endPage,
      required List<int> surahNumbers,
      required this.totalAyahs})
      : _surahNumbers = surahNumbers;

  @override
  int number;
  @override
  String nameArabic;
  @override
  String nameEnglish;
  @override
  int startPage;
  @override
  int endPage;
  List<int> _surahNumbers;
  @override
  List<int> get surahNumbers {
    if (_surahNumbers is EqualUnmodifiableListView) return _surahNumbers;
    return EqualUnmodifiableListView(_surahNumbers);
  }

  @override
  int totalAyahs;

  @override
  String toString() {
    return 'Juz(number: $number, nameArabic: $nameArabic, nameEnglish: $nameEnglish, startPage: $startPage, endPage: $endPage, surahNumbers: $surahNumbers, totalAyahs: $totalAyahs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JuzImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.nameArabic, nameArabic) ||
                other.nameArabic == nameArabic) &&
            (identical(other.nameEnglish, nameEnglish) ||
                other.nameEnglish == nameEnglish) &&
            (identical(other.startPage, startPage) ||
                other.startPage == startPage) &&
            (identical(other.endPage, endPage) ||
                other.endPage == endPage) &&
            const DeepCollectionEquality()
                .equals(other._surahNumbers, _surahNumbers) &&
            (identical(other.totalAyahs, totalAyahs) ||
                other.totalAyahs == totalAyahs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      number,
      nameArabic,
      nameEnglish,
      startPage,
      endPage,
      const DeepCollectionEquality().hash(_surahNumbers),
      totalAyahs);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JuzImplCopyWith<_$JuzImpl> get copyWith =>
      __$$JuzImplCopyWithImpl<_$JuzImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JuzImplToJson(this);
  }
}

abstract class _Juz implements Juz {
  const factory _Juz(
      {required final int number,
      required String nameArabic,
      required String nameEnglish,
      required int startPage,
      required int endPage,
      required List<int> surahNumbers,
      required int totalAyahs}) = _$JuzImpl;

  @override
  int get number;
  @override
  String get nameArabic;
  @override
  String get nameEnglish;
  @override
  int get startPage;
  @override
  int get endPage;
  @override
  List<int> get surahNumbers;
  @override
  int get totalAyahs;
  @override
  @JsonKey(ignore: true)
  _$$JuzImplCopyWith<_$JuzImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
