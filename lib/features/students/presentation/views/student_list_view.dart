import 'package:flutter/material.dart';
import "package:hafiz/core/localization/app_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/app_bar.dart';
import 'package:hafiz/core/widgets/badge.dart';
import 'package:hafiz/core/widgets/button.dart';
import 'package:hafiz/core/widgets/card.dart';
import 'package:hafiz/core/widgets/empty_state.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/core/widgets/search_bar.dart' as app;
import 'package:hafiz/features/students/domain/entities/student.dart';
import 'package:hafiz/features/students/domain/repositories/student_provider.dart';

class StudentListView extends ConsumerStatefulWidget {
  const StudentListView({super.key});

  @override
  ConsumerState<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends ConsumerState<StudentListView> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  StudentStatus? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/students/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: app.AppSearchBar(
              controller: _searchController,
              hintText: context.l.searchHint,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          _buildStatusFilter(),
          Expanded(
            child: studentsAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (students) {
                final filtered = _filterStudents(students);
                if (filtered.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.school_outlined,
                    title: context.l.emptyTitle,
                    description: context.l.emptyMessage,
                    primaryActionLabel: context.l.addStudent,
                    onPrimaryAction: () => context.push('/students/add'),
                  );
                }
                return _buildStudentList(filtered);
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
            label: Text(context.l.all),
            selected: _statusFilter == null,
            onSelected: (_) => setState(() => _statusFilter = null),
          ),
          const SizedBox(width: 8),
          ...StudentStatus.values.map(
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

  Widget _buildStudentList(List<Student> students) {
    return RefreshIndicator(
      onRefresh: () => ref.read(studentsProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return _StudentCard(
            student: student,
            onTap: () => context.push('/students/${student.id}'),
          );
        },
      ),
    );
  }

  List<Student> _filterStudents(List<Student> students) {
    return students.where((student) {
      final matchesSearch = _searchQuery.isEmpty ||
          student.fullName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (student.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
      final matchesStatus =
          _statusFilter == null || student.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({
    required this.student,
    required this.onTap,
  });

  final Student student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: student.avatarUrl != null
                ? NetworkImage(student.avatarUrl!)
                : null,
            child: student.avatarUrl == null
                ? Text(student.fullName[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.preferredName ?? student.fullName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (student.studentId != null)
                  Text(
                    'ID: ${student.studentId}',
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
    final color = switch (student.status) {
      StudentStatus.active => Colors.green,
      StudentStatus.suspended => Colors.orange,
      StudentStatus.withdrawn => Colors.red,
      StudentStatus.graduated => Colors.blue,
      _ => Colors.grey,
    };

    return AppBadge(
      label: student.status.displayNameAr,
      color: color,
    );
  }
}
