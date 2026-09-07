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
import 'package:hafiz/features/classes/domain/entities/school_class.dart';
import 'package:hafiz/features/classes/domain/repositories/class_provider.dart';

class ClassListView extends ConsumerStatefulWidget {
  const ClassListView({super.key});

  @override
  ConsumerState<ClassListView> createState() => _ClassListViewState();
}

class _ClassListViewState extends ConsumerState<ClassListView> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  ClassStatus? _statusFilter;
  ClassLevel? _levelFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classesAsync = ref.watch(classesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.classes.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/classes/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: app.SearchBar(
              controller: _searchController,
              hintText: context.l.classes.searchHint,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          _buildFilters(),
          Expanded(
            child: classesAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (classes) {
                final filtered = _filterClasses(classes);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.class_outlined,
                    title: context.l.classes.emptyTitle,
                    message: context.l.classes.emptyMessage,
                    actionLabel: context.l.classes.addClass,
                    onAction: () => context.push('/classes/add'),
                  );
                }
                return _buildClassList(filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          FilterChip(
            label: Text(context.l.common.all),
            selected: _statusFilter == null && _levelFilter == null,
            onSelected: (_) => setState(() {
              _statusFilter = null;
              _levelFilter = null;
            }),
          ),
          const SizedBox(width: 8),
          ...ClassStatus.values.map(
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

  Widget _buildClassList(List<SchoolClass> classes) {
    return RefreshIndicator(
      onRefresh: () => ref.read(classesProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final schoolClass = classes[index];
          return _ClassCard(
            schoolClass: schoolClass,
            onTap: () => context.push('/classes/${schoolClass.id}'),
          );
        },
      ),
    );
  }

  List<SchoolClass> _filterClasses(List<SchoolClass> classes) {
    return classes.where((schoolClass) {
      final matchesSearch = _searchQuery.isEmpty ||
          schoolClass.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (schoolClass.description
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false);
      final matchesStatus =
          _statusFilter == null || schoolClass.status == _statusFilter;
      final matchesLevel =
          _levelFilter == null || schoolClass.level == _levelFilter;
      return matchesSearch && matchesStatus && matchesLevel;
    }).toList();
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.schoolClass,
    required this.onTap,
  });

  final SchoolClass schoolClass;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  schoolClass.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.school,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                schoolClass.level.displayNameAr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.people,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${schoolClass.maxCapacity}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          if (schoolClass.daysOfWeek.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: schoolClass.daysOfWeek
                  .map((day) => Chip(
                        label: Text(day),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final color = switch (schoolClass.status) {
      ClassStatus.active => Colors.green,
      ClassStatus.inactive => Colors.grey,
      ClassStatus.completed => Colors.blue,
      ClassStatus.cancelled => Colors.red,
    };

    return AppBadge(
      label: schoolClass.status.displayNameAr,
      color: color,
    );
  }
}
