import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
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

class _ClassesTab extends StatelessWidget {
  const _ClassesTab({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('قريباً...', style: AppTextStyles.bodyLarge),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('قريباً...', style: AppTextStyles.bodyLarge),
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
