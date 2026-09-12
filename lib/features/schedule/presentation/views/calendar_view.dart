import 'package:flutter/material.dart';
import "package:hafiz/core/localization/app_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/features/schedule/domain/entities/schedule_event.dart';
import 'package:hafiz/features/schedule/domain/repositories/schedule_provider.dart';
import 'package:intl/intl.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.title),
      ),
      body: Column(
        children: [
          _buildCalendarHeader(),
          _buildCalendar(),
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _focusedDate = DateTime(
                  _focusedDate.year,
                  _focusedDate.month - 1,
                );
              });
            },
          ),
          Expanded(
            child: Text(
              DateFormat.yMMMM('ar').format(_focusedDate),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _focusedDate = DateTime(
                  _focusedDate.year,
                  _focusedDate.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedDate.year,
      _focusedDate.month,
    );
    final firstDay = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final startWeekday = firstDay.weekday;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: ['سبت', 'أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: (startWeekday - 1) + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startWeekday - 1) {
                return const SizedBox();
              }

              final day = index - (startWeekday - 1) + 1;
              final date = DateTime(
                _focusedDate.year,
                _focusedDate.month,
                day,
              );
              final isSelected = DateUtils.isSameDay(_selectedDate, date);
              final isToday = DateUtils.isSameDay(DateTime.now(), date);

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : isToday
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? Theme.of(context).colorScheme.primary
                                : null,
                        fontWeight: isToday || isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    final startOfDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final eventsAsync = ref.watch(eventsProvider(
      (start: startOfDay, end: endOfDay),
    ));

    return eventsAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (events) {
        if (events.isEmpty) {
          return Center(
            child: Text(context.l.noEvents),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _EventCard(event: event);
          },
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final ScheduleEvent event;

  @override
  Widget build(BuildContext context) {
    final color = switch (event.eventType) {
      EventType.classSession => Colors.blue,
      EventType.tasmi => Colors.green,
      EventType.exam => Colors.red,
      EventType.meeting => Colors.orange,
      EventType.holiday => Colors.purple,
      EventType.other => Colors.grey,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(event.title),
        subtitle: Text(
          '${DateFormat.jm('ar').format(event.startTime)} - ${DateFormat.jm('ar').format(event.endTime)}',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            event.eventType.displayNameAr,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
