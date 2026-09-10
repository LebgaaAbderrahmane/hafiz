import '../entities/report.dart';

/// Abstract repository for report operations.
abstract class ReportRepository {
  /// Get all reports for a branch.
  Future<List<Report>> getBranchReports({
    required String branchId,
    ReportType? type,
  });

  /// Get a single report by ID.
  Future<Report?> getReportById(String reportId);

  /// Generate a new report.
  Future<Report> generateReport({
    required String organizationId,
    required String branchId,
    required String generatedById,
    required ReportType type,
    required String title,
    Map<String, dynamic>? parameters,
    ReportFormat? format,
  });

  /// Delete a report.
  Future<void> deleteReport(String reportId);

  /// Get attendance report data.
  Future<Map<String, dynamic>> getAttendanceReportData({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? studentId,
  });

  /// Get memorization progress report data.
  Future<Map<String, dynamic>> getMemorizationProgressData({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? studentId,
  });

  /// Get tasmi summary report data.
  Future<Map<String, dynamic>> getTasmiSummaryData({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? studentId,
  });
}
