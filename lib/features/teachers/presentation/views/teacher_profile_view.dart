import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/features/teachers/domain/entities/teacher.dart';
import 'package:hafiz/features/teachers/domain/repositories/teacher_provider.dart';

class TeacherProfileView extends ConsumerWidget {
  const TeacherProfileView({super.key, required this.teacherId});

  final String teacherId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherAsync = ref.watch(teacherProvider(teacherId));

    return teacherAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (teacher) => _TeacherProfile(teacher: teacher),
    );
  }
}

class _TeacherProfile extends StatelessWidget {
  const _TeacherProfile({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(teacher.preferredName ?? teacher.fullName),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/teachers/${teacher.id}/edit'),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: context.l.teachers.tabInfo),
              Tab(text: context.l.teachers.tabClasses),
              Tab(text: context.l.teachers.tabSchedule),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildProfileHeader(context),
            Expanded(
              child: TabBarView(
                children: [
                  _InfoTab(teacher: teacher),
                  _ClassesTab(teacher: teacher),
                  _ScheduleTab(teacher: teacher),
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
            backgroundImage: teacher.avatarUrl != null
                ? NetworkImage(teacher.avatarUrl!)
                : null,
            child: teacher.avatarUrl == null
                ? Text(
                    teacher.fullName[0].toUpperCase(),
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
                  teacher.fullName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (teacher.specialization != null)
                  Text(
                    teacher.specialization!,
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
  const _InfoTab({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoRow(
          label: context.l.teachers.fullName,
          value: teacher.fullName,
        ),
        if (teacher.preferredName != null)
          _InfoRow(
            label: context.l.teachers.preferredName,
            value: teacher.preferredName!,
          ),
        if (teacher.gender != null)
          _InfoRow(
            label: context.l.teachers.gender,
            value: teacher.gender!.displayNameAr,
          ),
        if (teacher.dateOfBirth != null)
          _InfoRow(
            label: context.l.teachers.dateOfBirth,
            value:
                '${teacher.dateOfBirth!.day}/${teacher.dateOfBirth!.month}/${teacher.dateOfBirth!.year}',
          ),
        if (teacher.nationality != null)
          _InfoRow(
            label: context.l.teachers.nationality,
            value: teacher.nationality!,
          ),
        if (teacher.phone != null)
          _InfoRow(
            label: context.l.teachers.phone,
            value: teacher.phone!,
          ),
        if (teacher.email != null)
          _InfoRow(
            label: context.l.teachers.email,
            value: teacher.email!,
          ),
        if (teacher.specialization != null)
          _InfoRow(
            label: context.l.teachers.specialization,
            value: teacher.specialization!,
          ),
        if (teacher.qualifications.isNotEmpty)
          _InfoRow(
            label: context.l.teachers.qualifications,
            value: teacher.qualifications.join(', '),
          ),
        if (teacher.certifications.isNotEmpty)
          _InfoRow(
            label: context.l.teachers.certifications,
            value: teacher.certifications.join(', '),
          ),
        if (teacher.languagesSpoken.isNotEmpty)
          _InfoRow(
            label: context.l.teachers.languagesSpoken,
            value: teacher.languagesSpoken.join(', '),
          ),
        _InfoRow(
          label: context.l.teachers.status,
          value: teacher.status.displayNameAr,
        ),
        if (teacher.hireDate != null)
          _InfoRow(
            label: context.l.teachers.hireDate,
            value:
                '${teacher.hireDate!.day}/${teacher.hireDate!.month}/${teacher.hireDate!.year}',
          ),
        if (teacher.notes != null)
          _InfoRow(
            label: context.l.teachers.notes,
            value: teacher.notes!,
          ),
      ],
    );
  }
}

class _ClassesTab extends StatelessWidget {
  const _ClassesTab({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l.teachers.classesComingSoon),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l.teachers.scheduleComingSoon),
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
