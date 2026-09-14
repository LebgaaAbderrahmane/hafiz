import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/localization/app_localizations.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/teacher.dart';
import 'package:hafiz/core/widgets/drawer_icon_button.dart';
import 'package:hafiz/features/teachers/domain/repositories/teacher_provider.dart';

class TeacherListView extends ConsumerStatefulWidget {
  const TeacherListView({super.key});

  @override
  ConsumerState<TeacherListView> createState() => _TeacherListViewState();
}

class _TeacherListViewState extends ConsumerState<TeacherListView> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  TeacherStatus? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ref.watch(activeBranchIdProvider);
    final teachersAsync = ref.watch(branchTeachersProvider(branchId));

    return Scaffold(
      appBar: AppBar(
        leading: const DrawerIconButton(),
        title: Text(context.l.teachers),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/teachers/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.m),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.m),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          _buildStatusFilter(),
          Expanded(
            child: teachersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _buildErrorState(context, ref),
              data: (teachers) {
                final filtered = _filterTeachers(teachers);
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 64, color: AppColors.textHint),
                        Gap.l,
                        Text(context.l.teachers, style: AppTextStyles.bodyLarge),
                        Gap.s,
                        Text(
                          context.l.noData,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildTeacherList(filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.m),
        children: [
          FilterChip(
            label: Text(context.l.all),
            selected: _statusFilter == null,
            onSelected: (_) => setState(() => _statusFilter = null),
          ),
          Gap.s,
          ...TeacherStatus.values.map(
            (status) => Padding(
              padding: EdgeInsets.only(right: AppSpacing.s),
              child: FilterChip(
                label: Text(status.displayNameAr),
                selected: _statusFilter == status,
                onSelected: (_) => setState(() => _statusFilter = status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            Gap.l,
            Text(
              context.l.errorLoadingData,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Gap.s,
            Text(
              context.l.errorTryAgain,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gap.xl,
            ElevatedButton.icon(
              onPressed: () {
                final branchId = ref.read(activeBranchIdProvider);
                if (branchId != null) {
                  ref.invalidate(branchTeachersProvider(branchId));
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text(context.l.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherList(List<Teacher> teachers) {
    return RefreshIndicator(
      onRefresh: () async {
        final branchId = ref.read(activeBranchIdProvider);
        if (branchId != null) {
          ref.invalidate(branchTeachersProvider(branchId));
        }
      },
      child: ListView.builder(
        padding: EdgeInsets.all(AppSpacing.m),
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return _TeacherCard(
            teacher: teacher,
            onTap: () => context.push('/teachers/${teacher.id}'),
          );
        },
      ),
    );
  }

  List<Teacher> _filterTeachers(List<Teacher> teachers) {
    return teachers.where((teacher) {
      final matchesSearch = _searchQuery.isEmpty ||
          teacher.fullName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (teacher.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
      final matchesStatus =
          _statusFilter == null || teacher.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({
    required this.teacher,
    required this.onTap,
  });

  final Teacher teacher;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.s),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            teacher.fullName[0].toUpperCase(),
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
          ),
        ),
        title: Text(
          teacher.preferredName ?? teacher.fullName,
          style: AppTextStyles.titleSmall,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (teacher.specialization != null)
              Text(
                teacher.specialization!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            Gap.xs,
            _buildStatusBadge(context),
          ],
        ),
        trailing: const Icon(Icons.chevron_left),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final color = switch (teacher.status) {
      TeacherStatus.active => AppColors.success,
      TeacherStatus.onLeave => AppColors.warning,
      TeacherStatus.inactive => AppColors.textHint,
      TeacherStatus.terminated => AppColors.error,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.s),
      ),
      child: Text(
        teacher.status.displayNameAr,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }
}
