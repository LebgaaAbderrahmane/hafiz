// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SurahImpl _$$SurahImplFromJson(Map<String, dynamic> json) => _$SurahImpl(
      number: (json['number'] as num).toInt(),
      nameArabic: json['name_arabic'] as String,
      nameEnglish: json['name_english'] as String,
      nameTransliteration: json['name_transliteration'] as String,
      totalAyahs: (json['total_ayahs'] as num).toInt(),
      revelationType:
          $enumDecode(_$RevelationTypeEnumMap, json['revelation_type']),
      juz: (json['juz'] as num).toInt(),
      hizb: (json['hizb'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$SurahImplToJson(_$SurahImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name_arabic': instance.nameArabic,
      'name_english': instance.nameEnglish,
      'name_transliteration': instance.nameTransliteration,
      'total_ayahs': instance.totalAyahs,
      'revelation_type': _$RevelationTypeEnumMap[instance.revelationType]!,
      'juz': instance.juz,
      'hizb': instance.hizb,
      'page': instance.page,
      'description': instance.description,
    };

const _$RevelationTypeEnumMap = {
  RevelationType.meccan: 'meccan',
  RevelationType.medinan: 'medinan',
};

_$SurahImpl _$SurahFromJson(Map<String, dynamic> json) => _$$SurahImplFromJson(json);
Map<String, dynamic> _$SurahToJson(_$SurahImpl instance) => _$$SurahImplToJson(instance);
