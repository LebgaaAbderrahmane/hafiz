import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/app_bar.dart';
import 'package:hafiz/core/widgets/badge.dart';
import 'package:hafiz/core/widgets/card.dart';
import 'package:hafiz/core/widgets/empty_state.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/core/widgets/search_bar.dart' as app;
import 'package:hafiz/features/teachers/domain/entities/teacher.dart';
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
    final teachersAsync = ref.watch(teachersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.teachers.title),
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
            padding: const EdgeInsets.all(16),
            child: app.SearchBar(
              controller: _searchController,
              hintText: context.l.teachers.searchHint,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          _buildStatusFilter(),
          Expanded(
            child: teachersAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (teachers) {
                final filtered = _filterTeachers(teachers);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.person_outline,
                    title: context.l.teachers.emptyTitle,
                    message: context.l.teachers.emptyMessage,
                    actionLabel: context.l.teachers.addTeacher,
                    onAction: () => context.push('/teachers/add'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          FilterChip(
            label: Text(context.l.common.all),
            selected: _statusFilter == null,
            onSelected: (_) => setState(() => _statusFilter = null),
          ),
          const SizedBox(width: 8),
          ...TeacherStatus.values.map(
            (status) => Padding(
              padding: const EdgeInsets.only(right: 8),
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

  Widget _buildTeacherList(List<Teacher> teachers) {
    return RefreshIndicator(
      onRefresh: () => ref.read(teachersProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
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
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: teacher.avatarUrl != null
                ? NetworkImage(teacher.avatarUrl!)
                : null,
            child: teacher.avatarUrl == null
                ? Text(teacher.fullName[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.preferredName ?? teacher.fullName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (teacher.specialization != null)
                  Text(
                    teacher.specialization!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 4),
                _buildStatusBadge(context),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final color = switch (teacher.status) {
      TeacherStatus.active => Colors.green,
      TeacherStatus.onLeave => Colors.orange,
      TeacherStatus.inactive => Colors.grey,
      TeacherStatus.terminated => Colors.red,
    };

    return AppBadge(
      label: teacher.status.displayNameAr,
      color: color,
    );
  }
}
