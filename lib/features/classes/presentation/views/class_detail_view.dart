import 'package:flutter/material.dart';
import "package:hafiz/core/localization/app_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/theme/theme.dart';
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
              Tab(text: context.l.tabInfo),
              Tab(text: context.l.tabStudents),
              Tab(text: context.l.tabSchedule),
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
          label: context.l.name,
          value: schoolClass.name,
        ),
        if (schoolClass.description != null)
          _InfoRow(
            label: context.l.description,
            value: schoolClass.description!,
          ),
        _InfoRow(
          label: context.l.level,
          value: schoolClass.level.displayNameAr,
        ),
        _InfoRow(
          label: context.l.maxCapacity,
          value: '${schoolClass.maxCapacity}',
        ),
        _InfoRow(
          label: context.l.status,
          value: schoolClass.status.displayNameAr,
        ),
        if (schoolClass.daysOfWeek.isNotEmpty)
          _InfoRow(
            label: context.l.daysOfWeek,
            value: schoolClass.daysOfWeek.join(', '),
          ),
        if (schoolClass.startTime != null)
          _InfoRow(
            label: context.l.startTime,
            value: schoolClass.startTime!,
          ),
        if (schoolClass.endTime != null)
          _InfoRow(
            label: context.l.endTime,
            value: schoolClass.endTime!,
          ),
        if (schoolClass.startDate != null)
          _InfoRow(
            label: context.l.startDate,
            value:
                '${schoolClass.startDate!.day}/${schoolClass.startDate!.month}/${schoolClass.startDate!.year}',
          ),
        if (schoolClass.endDate != null)
          _InfoRow(
            label: context.l.endDate,
            value:
                '${schoolClass.endDate!.day}/${schoolClass.endDate!.month}/${schoolClass.endDate!.year}',
          ),
        if (schoolClass.notes != null)
          _InfoRow(
            label: context.l.notes,
            value: schoolClass.notes!,
          ),
      ],
    );
  }
}

class _StudentsTab extends ConsumerWidget {
  const _StudentsTab({required this.schoolClass});

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: AppColors.textHint),
          Gap.l,
          Text('طلاب الفصل', style: AppTextStyles.bodyLarge),
          Gap.s,
          Text(
            'سيتم عرض طلاب الفصل هنا',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Gap.m,
          OutlinedButton.icon(
            onPressed: () => context.push('/students/add'),
            icon: const Icon(Icons.person_add),
            label: const Text('إضافة طالب'),
          ),
        ],
      ),
    );
  }
}

class _ScheduleTab extends ConsumerWidget {
  const _ScheduleTab({required this.schoolClass});

  final SchoolClass schoolClass;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = schoolClass.daysOfWeek;
    final startTime = schoolClass.startTime;
    final endTime = schoolClass.endTime;

    if (days.isEmpty && startTime == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: AppColors.textHint),
            Gap.l,
            Text('جدول الحصص', style: AppTextStyles.bodyLarge),
            Gap.s,
            Text(
              'لم يتم تعيين جدول بعد',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(AppSpacing.m),
      children: [
        if (days.isNotEmpty) ...[
          Text('أيام الأسبوع', style: AppTextStyles.titleMedium),
          Gap.s,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days.map((day) => Chip(label: Text(day))).toList(),
          ),
          Gap.m,
        ],
        if (startTime != null && endTime != null) ...[
          Text('التوقيت', style: AppTextStyles.titleMedium),
          Gap.s,
          Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('$startTime - $endTime'),
              subtitle: const Text('مدة الحصة'),
            ),
          ),
        ],
      ],
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
