import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

/// Report entity.
///
/// Represents a generated report (attendance, progress, etc.).
@freezed
abstract class Report with _$Report {
  const factory Report({
    required String id,
    required String organizationId,
    required String branchId,
    required String generatedById,
    required ReportType type,
    required String title,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? data,
    ReportFormat? format,
    String? filePath,
    DateTime? generatedAt,
    required DateTime createdAt,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) =>
      _$ReportFromJson(json);
}

/// Report type.
enum ReportType {
  attendance,
  memorizationProgress,
  tasmiSummary,
  studentPerformance,
  teacherPerformance,
  classOverview,
  custom,
}

/// Report format.
enum ReportFormat {
  pdf,
  csv,
  excel,
}

/// Extension for display names.
extension ReportTypeExtension on ReportType {
  String get displayNameAr {
    return switch (this) {
      ReportType.attendance => 'تقرير الحصور',
      ReportType.memorizationProgress => 'تقرير تقدم الحفظ',
      ReportType.tasmiSummary => 'تقرير التسميع',
      ReportType.studentPerformance => 'تقرير أداء الطلاب',
      ReportType.teacherPerformance => 'تقرير أداء المعلمين',
      ReportType.classOverview => 'نظرة عامة على الفصل',
      ReportType.custom => 'تقرير مخصص',
    };
  }

  String get icon {
    return switch (this) {
      ReportType.attendance => '✓',
      ReportType.memorizationProgress => '📖',
      ReportType.tasmiSummary => '🎤',
      ReportType.studentPerformance => '📊',
      ReportType.teacherPerformance => '👨‍🏫',
      ReportType.classOverview => '🏫',
      ReportType.custom => '📋',
    };
  }
}

extension ReportFormatExtension on ReportFormat {
  String get displayNameAr {
    return switch (this) {
      ReportFormat.pdf => 'PDF',
      ReportFormat.csv => 'CSV',
      ReportFormat.excel => 'Excel',
    };
  }
}
