import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../../classes/domain/entities/school_class.dart';
import '../../../classes/domain/repositories/class_provider.dart';
import '../../../schedule/domain/entities/session.dart';
import '../../../schedule/domain/repositories/schedule_provider.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/teacher_provider.dart';

class TeacherProfileView extends ConsumerWidget {
  const TeacherProfileView({super.key, required this.teacherId});

  final String teacherId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملف المعلم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<Teacher?>(
        future: ref.read(teacherRepositoryProvider).getTeacherById(teacherId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final teacher = snapshot.data;
          if (teacher == null) {
            return Center(
              child: Text('المعلم غير موجود', style: AppTextStyles.bodyLarge),
            );
          }

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                _buildProfileHeader(context, teacher),
                TabBar(
                  tabs: const [
                    Tab(text: 'المعلومات'),
                    Tab(text: 'الفصول'),
                    Tab(text: 'الجدول'),
                  ],
                ),
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
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Teacher teacher) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.l),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              teacher.fullName[0].toUpperCase(),
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          Gap.m,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teacher.fullName, style: AppTextStyles.headlineSmall),
                if (teacher.specialization != null)
                  Text(
                    teacher.specialization!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
      padding: EdgeInsets.all(AppSpacing.m),
      children: [
        _InfoRow(label: 'الاسم الكامل', value: teacher.fullName),
        if (teacher.preferredName != null)
          _InfoRow(label: 'الاسم المفضل', value: teacher.preferredName!),
        if (teacher.gender != null)
          _InfoRow(label: 'الجنس', value: teacher.gender!.displayNameAr),
        if (teacher.dateOfBirth != null)
          _InfoRow(
            label: 'تاريخ الميلاد',
            value: '${teacher.dateOfBirth!.day}/${teacher.dateOfBirth!.month}/${teacher.dateOfBirth!.year}',
          ),
        if (teacher.nationality != null)
          _InfoRow(label: 'الجنسية', value: teacher.nationality!),
        if (teacher.phone != null)
          _InfoRow(label: 'الهاتف', value: teacher.phone!),
        if (teacher.email != null)
          _InfoRow(label: 'البريد الإلكتروني', value: teacher.email!),
        if (teacher.specialization != null)
          _InfoRow(label: 'التخصص', value: teacher.specialization!),
        if (teacher.qualifications.isNotEmpty)
          _InfoRow(label: 'المؤهلات', value: teacher.qualifications.join(', ')),
        if (teacher.certifications.isNotEmpty)
          _InfoRow(label: 'الشهادات', value: teacher.certifications.join(', ')),
        if (teacher.languagesSpoken.isNotEmpty)
          _InfoRow(label: 'اللغات', value: teacher.languagesSpoken.join(', ')),
        _InfoRow(label: 'الحالة', value: teacher.status.displayNameAr),
        if (teacher.hireDate != null)
          _InfoRow(
            label: 'تاريخ التوظيف',
            value: '${teacher.hireDate!.day}/${teacher.hireDate!.month}/${teacher.hireDate!.year}',
          ),
        if (teacher.notes != null)
          _InfoRow(label: 'ملاحظات', value: teacher.notes!),
      ],
    );
  }
}

class _ClassesTab extends ConsumerWidget {
  const _ClassesTab({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgId = ref.watch(activeOrganizationIdProvider);
    if (orgId == null) {
      return const SizedBox.shrink();
    }

    final classesAsync = ref.watch(
      _teacherClassesProvider(teacher.id),
    );

    return classesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('حدث خطأ في تحميل الفصول', style: AppTextStyles.bodyMedium),
      ),
      data: (classes) {
        if (classes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.class_outlined, size: 64, color: AppColors.textHint),
                Gap.l,
                Text('لا توجد فصول', style: AppTextStyles.bodyLarge),
                Gap.s,
                Text(
                  'لم يُسند أي فصل لهذا المعلم بعد',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppSpacing.m),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final schoolClass = classes[index];
            return Card(
              margin: EdgeInsets.only(bottom: AppSpacing.s),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schoolClass.name,
                      style: AppTextStyles.titleMedium,
                    ),
                    Gap.s,
                    Row(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        Gap.xs,
                        Text(
                          schoolClass.level.displayNameAr,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (schoolClass.daysOfWeek.isNotEmpty) ...[
                      Gap.s,
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          Gap.xs,
                          Expanded(
                            child: Text(
                              schoolClass.daysOfWeek.join(' - '),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (schoolClass.startTime != null &&
                        schoolClass.endTime != null) ...[
                      Gap.xs,
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          Gap.xs,
                          Text(
                            '${schoolClass.startTime} - ${schoolClass.endTime}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ScheduleTab extends ConsumerWidget {
  const _ScheduleTab({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 30));

    final sessionsAsync = ref.watch(
      _teacherSessionsProvider((teacherId: teacher.id, startDate: now, endDate: endDate)),
    );

    return sessionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('حدث خطأ في تحميل الجدول', style: AppTextStyles.bodyMedium),
      ),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 64, color: AppColors.textHint),
                Gap.l,
                Text('لا توجد حصص مجدولة', style: AppTextStyles.bodyLarge),
                Gap.s,
                Text(
                  'لا توجد حصص مجدولة لهذا المعلم خلال 30 يوماً',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppSpacing.m),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return Card(
              margin: EdgeInsets.only(bottom: AppSpacing.s),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            session.title,
                            style: AppTextStyles.titleMedium,
                          ),
                        ),
                        _SessionStatusChip(status: session.status),
                      ],
                    ),
                    Gap.s,
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        Gap.xs,
                        Text(
                          '${session.date.day}/${session.date.month}/${session.date.year}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Gap.xs,
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        Gap.xs,
                        Text(
                          '${session.startTime} - ${session.endTime}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Gap.xs,
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        Gap.xs,
                        Text(
                          session.type.displayNameAr,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

final _teacherClassesProvider =
    FutureProvider.autoDispose.family<List<SchoolClass>, String>((ref, teacherId) async {
  final orgId = ref.watch(activeOrganizationIdProvider);
  if (orgId == null) return [];

  final result = await ref.read(classRepositoryProvider).getClasses(
        organizationId: orgId,
        teacherId: teacherId,
      );

  return result.fold(
    (failure) => throw failure,
    (classes) => classes,
  );
});

final _teacherSessionsProvider = FutureProvider.autoDispose
    .family<List<Session>, ({String teacherId, DateTime startDate, DateTime endDate})>(
        (ref, params) async {
  final orgId = ref.watch(activeOrganizationIdProvider);
  if (orgId == null) return [];

  final result = await ref.read(scheduleRepositoryProvider).getSessions(
        organizationId: orgId,
        teacherId: params.teacherId,
        startDate: params.startDate,
        endDate: params.endDate,
      );

  return result.fold(
    (failure) => throw failure,
    (sessions) => sessions,
  );
});

class _SessionStatusChip extends StatelessWidget {
  const _SessionStatusChip({required this.status});

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      SessionStatus.scheduled => (AppColors.primary, 'مجدول'),
      SessionStatus.inProgress => (Colors.orange, 'قيد التنفيذ'),
      SessionStatus.completed => (Colors.green, 'مكتمل'),
      SessionStatus.cancelled => (Colors.red, 'ملغي'),
      SessionStatus.rescheduled => (Colors.purple, 'تمت الإعادة جدولة'),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.s),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
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
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
