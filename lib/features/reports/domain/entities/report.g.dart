// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) =>
    _$ReportImpl(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      branchId: json['branch_id'] as String,
      generatedById: json['generated_by_id'] as String,
      type: $enumDecode(_$ReportTypeEnumMap, json['type']),
      title: json['title'] as String,
      parameters: json['parameters'] as Map<String, dynamic>?,
      data: json['data'] as Map<String, dynamic>?,
      format: $enumDecodeNullable(_$ReportFormatEnumMap, json['format']),
      filePath: json['file_path'] as String?,
      generatedAt: json['generated_at'] == null
          ? null
          : DateTime.parse(json['generated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'generated_by_id': instance.generatedById,
      'type': _$ReportTypeEnumMap[instance.type]!,
      'title': instance.title,
      'parameters': instance.parameters,
      'data': instance.data,
      'format': _$ReportFormatEnumMap[instance.format],
      'file_path': instance.filePath,
      'generated_at': instance.generatedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ReportTypeEnumMap = {
  ReportType.attendance: 'attendance',
  ReportType.memorizationProgress: 'memorization_progress',
  ReportType.tasmiSummary: 'tasmi_summary',
  ReportType.studentPerformance: 'student_performance',
  ReportType.teacherPerformance: 'teacher_performance',
  ReportType.classOverview: 'class_overview',
  ReportType.custom: 'custom',
};

const _$ReportFormatEnumMap = {
  ReportFormat.pdf: 'pdf',
  ReportFormat.csv: 'csv',
  ReportFormat.excel: 'excel',
};
