import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/drawer_icon_button.dart';
import '../../../auth/domain/repositories/auth_provider.dart';
import 'package:hafiz/features/parent_portal/domain/entities/parent_student.dart';
import 'package:hafiz/features/parent_portal/domain/repositories/parent_provider.dart';

class ParentPortalView extends ConsumerStatefulWidget {
  const ParentPortalView({super.key});

  @override
  ConsumerState<ParentPortalView> createState() => _ParentPortalViewState();
}

class _ParentPortalViewState extends ConsumerState<ParentPortalView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(parentStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بوابة ولي الأمر'),
        leading: const DrawerIconButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'الرئيسية'),
            Tab(text: 'التقدم'),
            Tab(text: 'الحضور'),
            Tab(text: 'الجدول'),
          ],
        ),
      ),
      body: studentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildErrorState(e.toString()),
        data: (students) {
          if (students.isEmpty) return _buildEmptyState();
          return TabBarView(
            controller: _tabController,
            children: [
              _HomeTab(students: students),
              _ProgressTab(students: students),
              _AttendanceTab(students: students),
              _ScheduleTab(students: students),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            Gap.l,
            Text(
              'حدث خطأ',
              style: AppTextStyles.headlineMedium,
            ),
            Gap.s,
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gap.xl,
            ElevatedButton(
              onPressed: () => ref.invalidate(parentStudentsProvider),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.child_care, size: 64, color: AppColors.textHint),
            Gap.l,
            Text(
              'لم يتم ربط أي أطفال بعد',
              style: AppTextStyles.headlineMedium,
            ),
            Gap.s,
            Text(
              'سيظهر أبناؤك هنا بعد ربطهم بحسابك',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Student Selector ───────────────────────────────────────────────

class _StudentSelector extends StatelessWidget {
  const _StudentSelector({
    required this.students,
    required this.selectedId,
    required this.onSelected,
  });

  final List<ParentStudent> students;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (students.length == 1) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.l),
        itemCount: students.length,
        separatorBuilder: (_, __) => Gap.s,
        itemBuilder: (context, index) {
          final student = students[index];
          final isSelected = student.studentId == selectedId;
          return ChoiceChip(
            label: Text(student.preferredName ?? student.fullName),
            selected: isSelected,
            selectedColor: AppColors.primarySurface,
            labelStyle: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            onSelected: (_) => onSelected(student.studentId),
          );
        },
      ),
    );
  }
}

// ─── HOME TAB ───────────────────────────────────────────────────────

class _HomeTab extends ConsumerWidget {
  const _HomeTab({required this.students});

  final List<ParentStudent> students;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final selectedId = ref.watch(selectedStudentIdProvider);
    final selectedStudent = ref.watch(selectedStudentProvider);

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          _buildGreeting(user?.fullName),
          Gap.m,

          // Student selector
          _StudentSelector(
            students: students,
            selectedId: selectedId,
            onSelected: (id) =>
                ref.read(selectedStudentIdProvider.notifier).state = id,
          ),
          Gap.l,

          // Today's status card
          if (selectedStudent != null) ...[
            _buildTodayStatusCard(selectedStudent),
            Gap.xl,
          ],

          // Recent feedback (tasmi sessions)
          if (selectedId != null) ...[
            Text('آخر التقييمات', style: AppTextStyles.titleLarge),
            Gap.m,
            _RecentFeedbackSection(studentId: selectedId),
          ],
        ],
      ),
    );
  }

  Widget _buildGreeting(String? name) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً، ${name ?? 'ولي الأمر'}',
                style: AppTextStyles.headlineMedium,
              ),
              Gap.xs,
              Text(
                'تتبع تقدم أطفالك في حفظ القرآن',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodayStatusCard(ParentStudent student) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.child_care, color: AppColors.primary, size: 24),
                Gap.s,
                Text(student.preferredName ?? student.fullName,
                    style: AppTextStyles.titleLarge),
              ],
            ),
            Gap.m,
            Row(
              children: [
                _StatusChip(
                  label: 'الحضور',
                  value: '${(student.attendanceRate * 100).round()}%',
                  color: student.attendanceRate >= 0.8
                      ? AppColors.success
                      : AppColors.warning,
                ),
                Gap.m,
                _StatusChip(
                  label: 'التسميع',
                  value: '${student.tasmiPassCount} نجح',
                  color: AppColors.info,
                ),
                Gap.m,
                _StatusChip(
                  label: 'المستوى',
                  value: student.currentQuranLevel ?? '—',
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppSpacing.radiusSM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Gap.xs,
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentFeedbackSection extends ConsumerWidget {
  const _RecentFeedbackSection({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(parentTasmiSessionsProvider(studentId));

    return sessionsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Text(
        'خطأ في تحميل البيانات',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
      ),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Center(
                child: Text(
                  'لا توجد تقييمات بعد',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          children: sessions.take(3).map((session) {
            final outcomeColor = _outcomeColor(session.outcome);
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(AppSpacing.m),
                leading: CircleAvatar(
                  backgroundColor: outcomeColor.withValues(alpha: 0.12),
                  child: Icon(
                    _outcomeIcon(session.outcome),
                    color: outcomeColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  _sessionTypeLabel(session.sessionType),
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${_outcomeLabel(session.outcome)}${session.overallRating != null ? ' • التقييم: ${session.overallRating}' : ''}',
                  style: AppTextStyles.bodySmall,
                ),
                trailing: Text(
                  _formatDate(session.recordedAt),
                  style: AppTextStyles.caption,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─── PROGRESS TAB ───────────────────────────────────────────────────

class _ProgressTab extends ConsumerWidget {
  const _ProgressTab({required this.students});

  final List<ParentStudent> students;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedStudentIdProvider);
    final selectedStudent = ref.watch(selectedStudentProvider);

    if (selectedId == null || selectedStudent == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StudentSelector(
            students: students,
            selectedId: selectedId,
            onSelected: (id) =>
                ref.read(selectedStudentIdProvider.notifier).state = id,
          ),
          Gap.l,

          // Memorization stats
          Text('إحصائيات الحفظ', style: AppTextStyles.titleLarge),
          Gap.m,
          _MemorizationStatsCard(student: selectedStudent),
          Gap.xl,

          // Recent tasmi sessions
          Text('جلسات التسميع الأخيرة', style: AppTextStyles.titleLarge),
          Gap.m,
          _TasmiHistorySection(studentId: selectedId),
        ],
      ),
    );
  }
}

class _MemorizationStatsCard extends StatelessWidget {
  const _MemorizationStatsCard({required this.student});

  final ParentStudent student;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatRow(
              label: 'الصفحات المحفوظة',
              value: '${student.totalMemorizedPages}',
              icon: Icons.menu_book,
              color: AppColors.primary,
            ),
            Gap.m,
            _StatRow(
              label: 'مستوى الحفظ',
              value: student.memorizationLevel ?? 'غير محدد',
              icon: Icons.trending_up,
              color: AppColors.info,
            ),
            Gap.m,
            _StatRow(
              label: 'نسبة الحضور',
              value: '${(student.attendanceRate * 100).round()}%',
              icon: Icons.check_circle_outline,
              color: student.attendanceRate >= 0.8
                  ? AppColors.success
                  : AppColors.warning,
            ),
            Gap.m,
            _StatRow(
              label: 'جلسات التسميع',
              value: '${student.totalSessions}',
              icon: Icons.record_voice_over,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppSpacing.radiusSM,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        Gap.m,
        Expanded(
          child: Text(label, style: AppTextStyles.bodyMedium),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _TasmiHistorySection extends ConsumerWidget {
  const _TasmiHistorySection({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(parentTasmiSessionsProvider(studentId));

    return sessionsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Text(
        'خطأ في تحميل البيانات',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
      ),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Center(
                child: Text(
                  'لا توجد جلسات تسميع بعد',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          children: sessions.map((session) {
            final outcomeColor = _outcomeColor(session.outcome);
            return Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: outcomeColor.withValues(alpha: 0.12),
                      child: Icon(
                        _outcomeIcon(session.outcome),
                        color: outcomeColor,
                        size: 18,
                      ),
                    ),
                    Gap.m,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _sessionTypeLabel(session.sessionType),
                            style: AppTextStyles.bodyMedium
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (session.teacherNotes != null)
                            Text(
                              session.teacherNotes!,
                              style: AppTextStyles.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.s,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: outcomeColor.withValues(alpha: 0.12),
                            borderRadius: AppSpacing.radiusSM,
                          ),
                          child: Text(
                            _outcomeLabel(session.outcome),
                            style: AppTextStyles.caption.copyWith(
                              color: outcomeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Gap.xs,
                        Text(
                          _formatDate(session.recordedAt),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─── ATTENDANCE TAB ─────────────────────────────────────────────────

class _AttendanceTab extends ConsumerStatefulWidget {
  const _AttendanceTab({required this.students});

  final List<ParentStudent> students;

  @override
  ConsumerState<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<_AttendanceTab> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedStudentIdProvider);

    if (selectedId == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StudentSelector(
            students: widget.students,
            selectedId: selectedId,
            onSelected: (id) =>
                ref.read(selectedStudentIdProvider.notifier).state = id,
          ),
          Gap.l,

          // Month selector
          _buildMonthSelector(),
          Gap.l,

          // Calendar grid
          _buildCalendarHeader(),
          Gap.s,
          _CalendarGrid(
            month: _currentMonth,
            studentId: selectedId,
          ),
          Gap.xl,

          // Legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month - 1,
              );
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy', 'ar').format(_currentMonth),
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month + 1,
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    final days = ['س', 'ح', 'ث', 'أ', 'ث', 'ج', 'س'];
    return Row(
      children: days
          .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: AppSpacing.m,
      runSpacing: AppSpacing.s,
      children: [
        _LegendItem(color: AppColors.present, label: 'حاضر'),
        _LegendItem(color: AppColors.late, label: 'متأخر'),
        _LegendItem(color: AppColors.absent, label: 'غائب'),
        _LegendItem(color: AppColors.excused, label: 'مبرر'),
      ],
    );
  }
}

class _CalendarGrid extends ConsumerWidget {
  const _CalendarGrid({
    required this.month,
    required this.studentId,
  });

  final DateTime month;
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(
      parentAttendanceProvider(
        (studentId: studentId, month: month),
      ),
    );

    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final startWeekday = firstDay.weekday % 7; // Sunday = 0
    final daysInMonth = lastDay.day;

    return attendanceAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Text(
        'خطأ في تحميل بيانات الحضور',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
      ),
      data: (records) {
        final statusMap = <int, String>{};
        for (final r in records) {
          statusMap[r.date.day] = r.status;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: startWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < startWeekday) return const SizedBox.shrink();

            final day = index - startWeekday + 1;
            final status = statusMap[day];
            final color = _attendanceStatusColor(status);

            return Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: status != null
                      ? color.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: AppSpacing.radiusSM,
                  border: status != null
                      ? Border.all(color: color.withValues(alpha: 0.3))
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: status != null ? color : AppColors.textPrimary,
                      fontWeight: status != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        Gap.xs,
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

// ─── SCHEDULE TAB ───────────────────────────────────────────────────

class _ScheduleTab extends ConsumerWidget {
  const _ScheduleTab({required this.students});

  final List<ParentStudent> students;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedStudentIdProvider);

    if (selectedId == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StudentSelector(
            students: students,
            selectedId: selectedId,
            onSelected: (id) =>
                ref.read(selectedStudentIdProvider.notifier).state = id,
          ),
          Gap.l,

          Text('الجلسات القادمة', style: AppTextStyles.titleLarge),
          Gap.m,
          _UpcomingSessionsSection(studentId: selectedId),
        ],
      ),
    );
  }
}

class _UpcomingSessionsSection extends ConsumerWidget {
  const _UpcomingSessionsSection({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(parentUpcomingSessionsProvider(studentId));

    return sessionsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Text(
        'خطأ في تحميل البيانات',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
      ),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: AppColors.textHint),
                    Gap.m,
                    Text(
                      'لا توجد جلسات قادمة',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Column(
          children: sessions.map((session) {
            final typeColor = _sessionTypeColor(session.type);
            return Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: AppSpacing.radiusSM,
                      ),
                      child: Icon(
                        _sessionTypeIcon(session.type),
                        color: typeColor,
                        size: 24,
                      ),
                    ),
                    Gap.m,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.title,
                            style: AppTextStyles.bodyMedium
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Gap.xs,
                          Text(
                            '${_sessionTypeLabel(session.type)} • ${session.startTime} - ${session.endTime}',
                            style: AppTextStyles.bodySmall,
                          ),
                          if (session.location != null)
                            Text(
                              session.location!,
                              style: AppTextStyles.caption,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('d MMM', 'ar').format(session.date),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE', 'ar').format(session.date),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─── Helpers ────────────────────────────────────────────────────────

Color _outcomeColor(String outcome) {
  return switch (outcome) {
    'pass' => AppColors.success,
    'needsRevision' => AppColors.warning,
    'fail' => AppColors.error,
    _ => AppColors.textSecondary,
  };
}

IconData _outcomeIcon(String outcome) {
  return switch (outcome) {
    'pass' => Icons.check_circle,
    'needsRevision' => Icons.info_outline,
    'fail' => Icons.cancel,
    _ => Icons.help_outline,
  };
}

String _outcomeLabel(String outcome) {
  return switch (outcome) {
    'pass' => 'نجح',
    'needsRevision' => 'يحتاج مراجعة',
    'fail' => 'لم ينجح',
    _ => outcome,
  };
}

String _sessionTypeLabel(String type) {
  return switch (type) {
    'newMemorization' => 'حفظ جديد',
    'revision' => 'مراجعة',
    'comprehensiveRevision' => 'مراجعة شاملة',
    'exam' => 'امتحان',
    'classSession' => 'حصة دراسية',
    'tasmi' => 'تسميع',
    _ => type,
  };
}

Color _sessionTypeColor(String type) {
  return switch (type) {
    'newMemorization' => AppColors.primary,
    'revision' => AppColors.info,
    'comprehensiveRevision' => AppColors.secondary,
    'exam' => AppColors.warning,
    'classSession' => AppColors.accent,
    'tasmi' => AppColors.success,
    _ => AppColors.textSecondary,
  };
}

IconData _sessionTypeIcon(String type) {
  return switch (type) {
    'newMemorization' => Icons.book,
    'revision' => Icons.replay,
    'comprehensiveRevision' => Icons.library_books,
    'exam' => Icons.quiz,
    'classSession' => Icons.school,
    'tasmi' => Icons.record_voice_over,
    _ => Icons.event,
  };
}

Color _attendanceStatusColor(String? status) {
  return switch (status) {
    'present' => AppColors.present,
    'late' => AppColors.late,
    'absent' => AppColors.absent,
    'excused' => AppColors.excused,
    _ => AppColors.textHint,
  };
}

String _formatDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inDays == 0) return 'اليوم';
  if (diff.inDays == 1) return 'أمس';
  if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
  return DateFormat('d MMM', 'ar').format(date);
}
