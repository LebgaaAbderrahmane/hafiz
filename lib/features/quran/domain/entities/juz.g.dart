// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JuzImpl _$$JuzImplFromJson(Map<String, dynamic> json) => _$JuzImpl(
      number: (json['number'] as num).toInt(),
      nameArabic: json['name_arabic'] as String,
      nameEnglish: json['name_english'] as String,
      startPage: (json['start_page'] as num).toInt(),
      endPage: (json['end_page'] as num).toInt(),
      surahNumbers: (json['surah_numbers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      totalAyahs: (json['total_ayahs'] as num).toInt(),
    );

Map<String, dynamic> _$$JuzImplToJson(_$JuzImpl instance) => <String, dynamic>{
      'number': instance.number,
      'name_arabic': instance.nameArabic,
      'name_english': instance.nameEnglish,
      'start_page': instance.startPage,
      'end_page': instance.endPage,
      'surah_numbers': instance.surahNumbers,
      'total_ayahs': instance.totalAyahs,
    };

_$JuzImpl _$JuzFromJson(Map<String, dynamic> json) => _$$JuzImplFromJson(json);
Map<String, dynamic> _$JuzToJson(_$JuzImpl instance) => _$$JuzImplToJson(instance);
