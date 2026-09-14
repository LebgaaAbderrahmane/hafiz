import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/drawer_icon_button.dart';
import '../../domain/entities/tasmi_session.dart';
import '../../domain/repositories/tasmi_provider.dart';

/// Tasmi session list view.
///
/// Displays all tasmi sessions for the current branch with filtering.
class TasmiSessionListView extends ConsumerStatefulWidget {
  const TasmiSessionListView({super.key});

  @override
  ConsumerState<TasmiSessionListView> createState() =>
      _TasmiSessionListViewState();
}

class _TasmiSessionListViewState extends ConsumerState<TasmiSessionListView> {
  _FilterOption _filter = _FilterOption.all;
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    final sessions = ref.read(branchTasmiSessionsProvider).valueOrNull;
    if (sessions == null || sessions.length < 50) return;
    setState(() => _isLoadingMore = true);
    await ref.read(branchTasmiSessionsProvider.notifier).loadMore();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(branchTasmiSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const DrawerIconButton(),
        title: Text(context.l.tasmiSessionListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/tasmi/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: sessionsAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => _buildErrorState(context, ref),
              data: (sessions) {
                final filtered = _applyFilter(sessions);
                if (filtered.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.mic_none_outlined,
                    title: context.l.tasmiSessionEmptyTitle,
                    description: context.l.tasmiSessionEmptyDescription,
                    primaryActionLabel: context.l.tasmiSessionAddButton,
                    onPrimaryAction: () => context.push('/tasmi/add'),
                  );
                }
                return _buildSessionList(filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.s,
        ),
        children: _FilterOption.values.map((option) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.s),
            child: FilterChip(
              label: Text(option.label(context)),
              selected: _filter == option,
              onSelected: (_) => setState(() => _filter = option),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSessionList(List<TasmiSession> sessions) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(branchTasmiSessionsProvider);
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.l),
        itemCount: sessions.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == sessions.length) {
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final session = sessions[index];
          return _TasmiSessionCard(
            session: session,
            onTap: () => context.push('/tasmi/${session.id}'),
          );
        },
      ),
    );
  }

  List<TasmiSession> _applyFilter(List<TasmiSession> sessions) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfWeek = startOfToday.subtract(
      Duration(days: now.weekday - 1),
    );

    return sessions.where((session) {
      return switch (_filter) {
        _FilterOption.all => true,
        _FilterOption.today =>
          session.recordedAt.isAfter(startOfToday) ||
              session.recordedAt.isAtSameMomentAs(startOfToday),
        _FilterOption.thisWeek =>
          session.recordedAt.isAfter(startOfWeek) ||
              session.recordedAt.isAtSameMomentAs(startOfWeek),
      };
    }).toList();
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
              onPressed: () => ref.invalidate(branchTasmiSessionsProvider),
              icon: const Icon(Icons.refresh),
              label: Text(context.l.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _TasmiSessionCard extends StatelessWidget {
  const _TasmiSessionCard({
    required this.session,
    required this.onTap,
  });

  final TasmiSession session;
  final VoidCallback onTap;

  static const _surahNames = [
    'الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة', 'الأنعام',
    'الأعراف', 'الأنفال', 'التوبة', 'يونس', 'هود', 'يوسف',
    'الرعد', 'إبراهيم', 'الحجر', 'النحل', 'الإسراء', 'الكهف',
    'مريم', 'طه', 'الأنبياء', 'الحج', 'المؤمنون', 'النور',
    'الفرقان', 'الشعراء', 'النمل', 'القصص', 'العنكبوت', 'الروم',
    'لقمان', 'السجدة', 'الأحزاب', 'سبأ', 'فاطر', 'يس',
    'الصافات', 'ص', 'الزمر', 'غافر', 'فصلت', 'الشورى',
    'الزخرف', 'الدخان', 'الجاثية', 'الأحقاف', 'محمد', 'الفتح',
    'الحجرات', 'ق', 'الذاريات', 'الطور', 'النجم', 'القمر',
    'الرحمن', 'الواقعة', 'الحديد', 'المجادلة', 'الحشر', 'الممتحنة',
    'الصف', 'الجمعة', 'المنافقون', 'التغابن', 'الطلاق', 'التحريم',
    'الملك', 'القلم', 'الحاقة', 'المعارج', 'نوح', 'الجن',
    'المزمل', 'المدثر', 'القيامة', 'الإنسان', 'المرسلات',
    'النبأ', 'النازعات', 'عبس', 'التكوير', 'الانفطار', 'المطففين',
    'الانشقاق', 'البروج', 'الطارق', 'الأعلى', 'الغاشية', 'الفجر',
    'البلد', 'الشمس', 'الليل', 'الضحى', 'الشرح', 'التين',
    'العلق', 'القدر', 'البينة', 'الزلزلة', 'العاديات', 'القارعة',
    'التكاثر', 'العصر', 'الهمزة', 'الفيل', 'قريش', 'الماعون',
    'الكوثر', 'الكافرون', 'النصر', 'المسد', 'الإخلاص', 'الفلق',
    'الناس',
  ];

  String _getSurahName(int surahNumber) {
    if (surahNumber >= 1 && surahNumber <= _surahNames.length) {
      return _surahNames[surahNumber - 1];
    }
    return 'سورة $surahNumber';
  }

  AppBadgeVariant _outcomeVariant(TasmiOutcome outcome) {
    return switch (outcome) {
      TasmiOutcome.pass => AppBadgeVariant.success,
      TasmiOutcome.needsRevision => AppBadgeVariant.warning,
      TasmiOutcome.fail => AppBadgeVariant.error,
    };
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(sessionDate).inDays;

    if (diff == 0) return context.l.today;
    if (diff == 1) return context.l.yesterday;
    if (diff < 7) return '$diff أيام';
    return DateFormat('dd/MM/yyyy', 'ar').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a', 'ar').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final passage =
        '${_getSurahName(session.startSurah)} ${session.startAyah}'
        ' - '
        '${_getSurahName(session.endSurah)} ${session.endAyah}';

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'طالب: ${session.studentId.substring(0, 8)}...',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              AppBadge(
                label: session.outcome.displayNameAr,
                variant: _outcomeVariant(session.outcome),
              ),
            ],
          ),
          Gap.s,
          Text(
            passage,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Gap.xs,
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${_formatDate(context, session.recordedAt)} - ${_formatTime(session.recordedAt)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          if (_hasScores(session)) ...[
            Gap.xs,
            _buildScoresRow(context),
          ],
        ],
      ),
    );
  }

  bool _hasScores(TasmiSession session) {
    return session.accuracyScore != null ||
        session.tajwidScore != null ||
        session.fluencyScore != null;
  }

  Widget _buildScoresRow(BuildContext context) {
    final scores = <String>[];
    if (session.accuracyScore != null) {
      scores.add('${context.l.tasmiAccuracy}: ${session.accuracyScore}/10');
    }
    if (session.tajwidScore != null) {
      scores.add('${context.l.tasmiTajwid}: ${session.tajwidScore}/10');
    }
    if (session.fluencyScore != null) {
      scores.add('${context.l.tasmiFluency}: ${session.fluencyScore}/10');
    }
    if (session.overallRating != null) {
      scores.add('${context.l.tasmiRating}: ${session.overallRating}/10');
    }

    return Row(
      children: [
        Icon(Icons.star_outline, size: 14, color: AppColors.warning),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            scores.join(' | '),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

enum _FilterOption {
  all,
  today,
  thisWeek;

  String label(BuildContext context) => switch (this) {
        all => context.l.all,
        today => context.l.today,
        thisWeek => context.l.tasmiFilterThisWeek,
      };
}
