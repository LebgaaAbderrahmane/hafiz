import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/features/classes/domain/entities/school_class.dart';
import 'package:hafiz/features/classes/domain/repositories/class_provider.dart';

class ClassDetailView extends ConsumerWidget {
  const ClassDetailView({super.key, required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classAsync = ref.watch(classProvider(classId));

    return classAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (schoolClass) => _ClassDetail(schoolClass: schoolClass),
    );
  }
}

class _ClassDetail extends StatelessWidget {
  const _ClassDetail({required this.schoolClass});

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(schoolClass.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/classes/${schoolClass.id}/edit'),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: context.l.classes.tabInfo),
              Tab(text: context.l.classes.tabStudents),
              Tab(text: context.l.classes.tabSchedule),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildClassHeader(context),
            Expanded(
              child: TabBarView(
                children: [
                  _InfoTab(schoolClass: schoolClass),
                  _StudentsTab(schoolClass: schoolClass),
                  _ScheduleTab(schoolClass: schoolClass),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.class_,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schoolClass.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  schoolClass.level.displayNameAr,
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
  const _InfoTab({required this.schoolClass});

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoRow(
          label: context.l.classes.name,
          value: schoolClass.name,
        ),
        if (schoolClass.description != null)
          _InfoRow(
            label: context.l.classes.description,
            value: schoolClass.description!,
          ),
        _InfoRow(
          label: context.l.classes.level,
          value: schoolClass.level.displayNameAr,
        ),
        _InfoRow(
          label: context.l.classes.maxCapacity,
          value: '${schoolClass.maxCapacity}',
        ),
        _InfoRow(
          label: context.l.classes.status,
          value: schoolClass.status.displayNameAr,
        ),
        if (schoolClass.daysOfWeek.isNotEmpty)
          _InfoRow(
            label: context.l.classes.daysOfWeek,
            value: schoolClass.daysOfWeek.join(', '),
          ),
        if (schoolClass.startTime != null)
          _InfoRow(
            label: context.l.classes.startTime,
            value: schoolClass.startTime!,
          ),
        if (schoolClass.endTime != null)
          _InfoRow(
            label: context.l.classes.endTime,
            value: schoolClass.endTime!,
          ),
        if (schoolClass.startDate != null)
          _InfoRow(
            label: context.l.classes.startDate,
            value:
                '${schoolClass.startDate!.day}/${schoolClass.startDate!.month}/${schoolClass.startDate!.year}',
          ),
        if (schoolClass.endDate != null)
          _InfoRow(
            label: context.l.classes.endDate,
            value:
                '${schoolClass.endDate!.day}/${schoolClass.endDate!.month}/${schoolClass.endDate!.year}',
          ),
        if (schoolClass.notes != null)
          _InfoRow(
            label: context.l.classes.notes,
            value: schoolClass.notes!,
          ),
      ],
    );
  }
}

class _StudentsTab extends StatelessWidget {
  const _StudentsTab({required this.schoolClass});

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l.classes.studentsComingSoon),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab({required this.schoolClass});

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l.classes.scheduleComingSoon),
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
