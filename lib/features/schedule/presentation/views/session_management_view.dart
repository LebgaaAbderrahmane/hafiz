import 'package:flutter/material.dart';
import "package:hafiz/core/localization/app_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/widgets/badge.dart';
import 'package:hafiz/core/widgets/card.dart';
import 'package:hafiz/core/widgets/empty_state.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/features/schedule/domain/entities/session.dart';
import 'package:hafiz/features/schedule/domain/repositories/schedule_provider.dart';
import 'package:intl/intl.dart';

class SessionManagementView extends ConsumerStatefulWidget {
  const SessionManagementView({super.key});

  @override
  ConsumerState<SessionManagementView> createState() =>
      _SessionManagementViewState();
}

class _SessionManagementViewState extends ConsumerState<SessionManagementView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.sessions),
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: _buildSessionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: 30,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = DateUtils.isSameDay(_selectedDate, date);
          final isToday = DateUtils.isSameDay(DateTime.now(), date);

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : isToday
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E('ar').format(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionsList() {
    final startOfDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final sessionsAsync = ref.watch(sessionsProvider(
      (start: startOfDay, end: endOfDay),
    ));

    return sessionsAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (sessions) {
        if (sessions.isEmpty) {
          return AppEmptyState(
            icon: Icons.event_available_outlined,
            title: context.l.noSessions,
            description: context.l.noSessionsMessage,
            primaryActionLabel: context.l.addSession,
            onPrimaryAction: () {
              // TODO: Navigate to add session
            },
          );
        }
        return _buildSessionList(sessions);
      },
    );
  }

  Widget _buildSessionList(List<Session> sessions) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return _SessionCard(session: session);
        },
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final color = switch (session.type) {
      SessionType.classSession => Colors.blue,
      SessionType.tasmi => Colors.green,
      SessionType.revision => Colors.orange,
      SessionType.exam => Colors.red,
      SessionType.makeup => Colors.purple,
      SessionType.other => Colors.grey,
    };

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${session.startTime} - ${session.endTime}',
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
                      '${session.studentIds.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildStatusBadge(context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final color = switch (session.status) {
      SessionStatus.scheduled => Colors.blue,
      SessionStatus.inProgress => Colors.orange,
      SessionStatus.completed => Colors.green,
      SessionStatus.cancelled => Colors.red,
      SessionStatus.rescheduled => Colors.purple,
    };

    return AppBadge(
      label: session.status.displayNameAr,
      color: color,
    );
  }
}
