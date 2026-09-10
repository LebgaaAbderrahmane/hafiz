import 'package:flutter/material.dart';
import "package:hafiz/core/localization/app_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/features/students/domain/entities/student.dart';
import 'package:hafiz/features/students/domain/repositories/student_provider.dart';

class StudentProfileView extends ConsumerWidget {
  const StudentProfileView({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProvider(studentId));

    return studentAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (student) => _StudentProfile(student: student),
    );
  }
}

class _StudentProfile extends StatelessWidget {
  const _StudentProfile({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(student.preferredName ?? student.fullName),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/students/${student.id}/edit'),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: context.l.tabInfo),
              Tab(text: context.l.tabQuran),
              Tab(text: context.l.tabAttendance),
              Tab(text: context.l.tabPerformance),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildProfileHeader(context),
            Expanded(
              child: TabBarView(
                children: [
                  _InfoTab(student: student),
                  _QuranTab(student: student),
                  _AttendanceTab(student: student),
                  _PerformanceTab(student: student),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: student.avatarUrl != null
                ? NetworkImage(student.avatarUrl!)
                : null,
            child: student.avatarUrl == null
                ? Text(
                    student.fullName[0].toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (student.studentId != null)
                  Text(
                    'ID: ${student.studentId}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  const _InfoTab({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoRow(
          label: context.l.fullName,
          value: student.fullName,
        ),
        if (student.preferredName != null)
          _InfoRow(
            label: context.l.preferredName,
            value: student.preferredName!,
          ),
        if (student.gender != null)
          _InfoRow(
            label: context.l.gender,
            value: student.gender!.displayNameAr,
          ),
        if (student.dateOfBirth != null)
          _InfoRow(
            label: context.l.dateOfBirth,
            value: '${student.dateOfBirth!.day}/${student.dateOfBirth!.month}/${student.dateOfBirth!.year}',
          ),
        if (student.nationality != null)
          _InfoRow(
            label: context.l.nationality,
            value: student.nationality!,
          ),
        if (student.phone != null)
          _InfoRow(
            label: context.l.phone,
            value: student.phone!,
          ),
        if (student.email != null)
          _InfoRow(
            label: context.l.email,
            value: student.email!,
          ),
        _InfoRow(
          label: context.l.status,
          value: student.status.displayNameAr,
        ),
        if (student.previousQuranEducation != null)
          _InfoRow(
            label: context.l.previousEducation,
            value: student.previousQuranEducation!,
          ),
      ],
    );
  }
}

class _QuranTab extends StatelessWidget {
  const _QuranTab({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoRow(
          label: context.l.currentQuranLevel,
          value: student.currentQuranLevel ?? '-',
        ),
        _InfoRow(
          label: context.l.readingLevel,
          value: student.readingLevel ?? '-',
        ),
        _InfoRow(
          label: context.l.tajwidLevel,
          value: student.tajwidLevel ?? '-',
        ),
        _InfoRow(
          label: context.l.memorizationLevel,
          value: student.memorizationLevel ?? '-',
        ),
      ],
    );
  }
}

class _AttendanceTab extends StatelessWidget {
  const _AttendanceTab({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l.attendanceComingSoon),
    );
  }
}

class _PerformanceTab extends StatelessWidget {
  const _PerformanceTab({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l.performanceComingSoon),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
