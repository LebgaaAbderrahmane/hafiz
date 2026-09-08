import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/button.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/features/attendance/domain/entities/attendance.dart';
import 'package:hafiz/features/attendance/domain/repositories/attendance_provider.dart';
import 'package:hafiz/features/students/domain/entities/student.dart';
import 'package:hafiz/features/students/domain/repositories/student_provider.dart';

/// Rapid attendance marking view.
///
/// Teacher sees a list of students and taps to cycle through statuses.
/// Designed for speed: tap once = present, tap again = late, etc.
class AttendanceMarkingView extends ConsumerStatefulWidget {
  const AttendanceMarkingView({
    super.key,
    required this.sessionId,
    required this.classId,
  });

  final String sessionId;
  final String.classId;

  @override
  ConsumerState<AttendanceMarkingView> createState() =>
      _AttendanceMarkingViewState();
}

class _AttendanceMarkingViewState
    extends ConsumerState<AttendanceMarkingView> {
  final Map<String, AttendanceStatus> _statusMap = {};
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsProvider);
    final attendanceAsync = ref.watch(
      sessionAttendanceProvider(widget.sessionId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.attendance.markAttendance),
        actions: [
          _buildSummaryChip(),
        ],
      ),
      body: Column(
        children: [
          _buildLegend(),
          Expanded(
            child: studentsAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (students) {
                if (students.isEmpty) {
                  return Center(child: Text(context.l.attendance.noStudents));
                }
                return attendanceAsync.when(
                  loading: () => const AppLoading(),
                  error: (e, _) => Center(child: Text(e.toString())),
                  data: (existing) {
                    // Pre-fill with existing attendance
                    for (final record in existing) {
                      if (!_statusMap.containsKey(record.studentId)) {
                        _statusMap[record.studentId] = record.status;
                      }
                    }
                    return _buildStudentList(students);
                  },
                );
              },
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSummaryChip() {
    final present = _statusMap.values
        .where((s) => s == AttendanceStatus.present)
        .length;
    final total = _statusMap.length;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          '$present/$total ${context.l.attendance.present}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: AttendanceStatus.values.map((status) {
          return Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(status.colorValue),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                status.displayNameAr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStudentList(List<Student> students) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        final status = _statusMap[student.id] ?? AttendanceStatus.present;

        return _AttendanceTile(
          student: student,
          status: status,
          onTap: () => _cycleStatus(student.id),
        );
      },
    );
  }

  void _cycleStatus(String studentId) {
    setState(() {
      final current = _statusMap[studentId] ?? AttendanceStatus.present;
      final values = AttendanceStatus.values;
      final nextIndex = (values.indexOf(current) + 1) % values.length;
      _statusMap[studentId] = values[nextIndex];
    });
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppButton(
        label: _saving ? context.l.common.saving : context.l.common.save,
        onPressed: _saving ? null : _save,
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    try {
      await ref.read(attendanceRepositoryProvider).bulkMarkAttendance(
            sessionId: widget.sessionId,
            classId: widget.classId,
            studentStatuses: _statusMap,
          );

      if (mounted) {
        ref.invalidate(sessionAttendanceProvider(widget.sessionId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.attendance.saved)),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _AttendanceTile extends StatelessWidget {
  const _AttendanceTile({
    required this.student,
    required this.status,
    required this.onTap,
  });

  final Student student;
  final AttendanceStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: student.avatarUrl != null
            ? NetworkImage(student.avatarUrl!)
            : null,
        child: student.avatarUrl == null
            ? Text(student.fullName[0].toUpperCase())
            : null,
      ),
      title: Text(student.preferredName ?? student.fullName),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Color(status.colorValue).withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          status.displayNameAr,
          style: TextStyle(
            color: Color(status.colorValue),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
