import 'package:flutter/material.dart';
import 'package:hafiz/core/localization/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/theme/theme.dart';
import 'package:hafiz/core/widgets/app_badge.dart';
import 'package:hafiz/core/widgets/app_empty_state.dart';
import 'package:hafiz/core/widgets/app_error_widget.dart';
import 'package:hafiz/core/widgets/app_loading.dart';
import 'package:hafiz/features/attendance/domain/entities/attendance.dart';
import 'package:hafiz/features/attendance/domain/repositories/attendance_provider.dart';
import 'package:hafiz/features/classes/domain/entities/school_class.dart';
import 'package:hafiz/features/classes/domain/repositories/class_provider.dart';
import 'package:hafiz/features/students/domain/entities/student.dart';
import 'package:hafiz/features/students/domain/repositories/student_provider.dart';

class AttendanceHistoryView extends ConsumerStatefulWidget {
  const AttendanceHistoryView({super.key});

  @override
  ConsumerState<AttendanceHistoryView> createState() =>
      _AttendanceHistoryViewState();
}

class _AttendanceHistoryViewState extends ConsumerState<AttendanceHistoryView> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedClassId;

  @override
  Widget build(BuildContext context) {
    final classesAsync = ref.watch(classesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.attendanceHistory),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: context.l.markAttendance,
            onPressed: _selectedClassId != null
                ? () => context.push(
                      '/attendance/mark?classId=$_selectedClassId',
                    )
                : null,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDatePicker(),
          _buildClassSelector(classesAsync),
          Expanded(
            child: _selectedClassId == null
                ? _buildEmptyClassSelection()
                : _buildAttendanceContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.s,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: AppSpacing.radiusMD,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    Gap.s,
                    Text(
                      _formatDate(_selectedDate),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassSelector(AsyncValue<List<SchoolClass>> classesAsync) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: classesAsync.when(
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('خطأ: $e', style: const TextStyle(color: AppColors.error)),
        data: (classes) {
          if (classes.isEmpty) {
            return const SizedBox.shrink();
          }
          return DropdownButtonFormField<String>(
            initialValue: _selectedClassId,
            decoration: InputDecoration(
              labelText: context.l.selectClass,
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.m,
              ),
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(context.l.allClasses),
              ),
              ...classes.map(
                (c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedClassId = value);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyClassSelection() {
    return AppEmptyState(
      title: context.l.selectClass,
      description: 'اختر فصلاً لعرض سجل الحضور',
      icon: Icons.class_,
    );
  }

  Widget _buildAttendanceContent() {
    final studentsAsync = ref.watch(studentsProvider);

    return studentsAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(studentsProvider),
      ),
      data: (students) {
        if (students.isEmpty) {
          return AppEmptyState(
            title: context.l.noStudents,
            icon: Icons.people_outline,
          );
        }

        final filteredStudents = _selectedClassId != null
            ? students // Show all org students for now (class linking TBD)
            : students;

        return _buildStudentAttendanceList(filteredStudents);
      },
    );
  }

  Widget _buildStudentAttendanceList(List<Student> students) {
    final attendanceAsync = ref.watch(
      classAttendanceHistoryProvider((
        classId: _selectedClassId!,
        startDate: DateTime(_selectedDate.year, _selectedDate.month, 1),
        endDate: _selectedDate,
      )),
    );

    return attendanceAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(
          classAttendanceHistoryProvider((
            classId: _selectedClassId!,
            startDate: DateTime(_selectedDate.year, _selectedDate.month, 1),
            endDate: _selectedDate,
          )),
        ),
      ),
      data: (attendanceRecords) {
        if (attendanceRecords.isEmpty) {
          return AppEmptyState(
            title: context.l.noAttendanceRecords,
            description: context.l.noAttendanceRecordsMessage,
            icon: Icons.event_busy,
            primaryActionLabel: context.l.markAttendance,
            onPrimaryAction: () => context.push(
              '/attendance/mark?classId=$_selectedClassId',
            ),
          );
        }

        return _buildStudentList(students, attendanceRecords);
      },
    );
  }

  Widget _buildStudentList(
    List<Student> students,
    List<Attendance> attendanceRecords,
  ) {
    final studentAttendanceMap = <String, List<Attendance>>{};
    for (final record in attendanceRecords) {
      studentAttendanceMap.putIfAbsent(record.studentId, () => []).add(record);
    }

    final todayRecords = attendanceRecords
        .where((r) =>
            r.date?.year == _selectedDate.year &&
            r.date?.month == _selectedDate.month &&
            r.date?.day == _selectedDate.day)
        .toList();

    final todayStatusMap = <String, AttendanceStatus>{};
    for (final record in todayRecords) {
      todayStatusMap[record.studentId] = record.status;
    }

    return Column(
      children: [
        _buildDaySummary(todayRecords, students.length),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.s,
            ),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final studentRecords = studentAttendanceMap[student.id] ?? [];
              final todayStatus = todayStatusMap[student.id];
              final monthPercentage = _calculateMonthPercentage(studentRecords);

              return _StudentAttendanceCard(
                student: student,
                todayStatus: todayStatus,
                monthPercentage: monthPercentage,
                totalSessions: studentRecords.length,
                presentCount: studentRecords
                    .where((r) =>
                        r.status == AttendanceStatus.present ||
                        r.status == AttendanceStatus.late)
                    .length,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDaySummary(List<Attendance> todayRecords, int totalStudents) {
    final presentCount = todayRecords
        .where((r) => r.status == AttendanceStatus.present)
        .length;
    final lateCount = todayRecords
        .where((r) => r.status == AttendanceStatus.late)
        .length;
    final absentCount = todayRecords
        .where((r) => r.status == AttendanceStatus.absent)
        .length;
    final excusedCount = todayRecords
        .where((r) => r.status == AttendanceStatus.excused)
        .length;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            count: presentCount,
            label: context.l.present,
            color: AppColors.present,
          ),
          _SummaryItem(
            count: lateCount,
            label: context.l.late,
            color: AppColors.late,
          ),
          _SummaryItem(
            count: absentCount,
            label: context.l.absent,
            color: AppColors.absent,
          ),
          _SummaryItem(
            count: excusedCount,
            label: context.l.excused,
            color: AppColors.excused,
          ),
        ],
      ),
    );
  }

  double _calculateMonthPercentage(List<Attendance> records) {
    if (records.isEmpty) return 0.0;
    final presentOrLate = records
        .where((r) =>
            r.status == AttendanceStatus.present ||
            r.status == AttendanceStatus.late)
        .length;
    return presentOrLate / records.length;
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final days = [
      'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء',
      'الخميس', 'الجمعة', 'السبت'
    ];
    return '${days[date.weekday % 7]} ${date.day} ${months[date.month - 1]}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: AppTextStyles.titleLarge.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap.xs,
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StudentAttendanceCard extends StatelessWidget {
  const _StudentAttendanceCard({
    required this.student,
    required this.todayStatus,
    required this.monthPercentage,
    required this.totalSessions,
    required this.presentCount,
  });

  final Student student;
  final AttendanceStatus? todayStatus;
  final double monthPercentage;
  final int totalSessions;
  final int presentCount;

  @override
  Widget build(BuildContext context) {
    final displayName = student.preferredName ?? student.fullName;
    final percentageText = '${(monthPercentage * 100).toInt()}%';

    return Card(
      margin: EdgeInsetsDirectional.only(bottom: AppSpacing.s),
      child: Padding(
        padding: EdgeInsetsDirectional.all(AppSpacing.m),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: student.avatarUrl != null
                  ? NetworkImage(student.avatarUrl!)
                  : null,
              child: student.avatarUrl == null
                  ? Text(
                      displayName.isNotEmpty ? displayName[0] : '?',
                      style: AppTextStyles.titleMedium,
                    )
                  : null,
            ),
            Gap.s,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap.xs,
                  Text(
                    '${context.l.monthlyAttendance}: $presentCount/$totalSessions',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (todayStatus != null)
                  AppBadge(
                    label: todayStatus!.displayNameAr,
                    variant: _getBadgeVariant(todayStatus!),
                    size: AppBadgeSize.small,
                  ),
                Gap.xs,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: monthPercentage,
                          backgroundColor: AppColors.surfaceVariant,
                          color: _getPercentageColor(monthPercentage),
                        ),
                      ),
                    ),
                    Gap.xs,
                    Text(
                      percentageText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _getPercentageColor(monthPercentage),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBadgeVariant _getBadgeVariant(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => AppBadgeVariant.success,
      AttendanceStatus.late => AppBadgeVariant.warning,
      AttendanceStatus.absent => AppBadgeVariant.error,
      AttendanceStatus.excused => AppBadgeVariant.info,
      AttendanceStatus.leftEarly => AppBadgeVariant.warning,
    };
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 0.8) return AppColors.success;
    if (percentage >= 0.5) return AppColors.warning;
    return AppColors.error;
  }
}
