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
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/revision.dart';
import '../../domain/repositories/revision_provider.dart';

/// Revision tracking view — shows revision schedule and progress.
///
/// Displays summary cards (Due Today, Overdue, Weak, Strong) at the top,
/// followed by a filterable list of revision items with "Start Revision" actions.
class RevisionTrackingView extends ConsumerStatefulWidget {
  final String? studentId;

  const RevisionTrackingView({super.key, this.studentId});

  @override
  ConsumerState<RevisionTrackingView> createState() =>
      _RevisionTrackingViewState();
}

class _RevisionTrackingViewState extends ConsumerState<RevisionTrackingView> {
  _FilterOption _filter = _FilterOption.all;

  @override
  Widget build(BuildContext context) {
    final studentId = widget.studentId;
    final branchId = ref.watch(activeBranchIdProvider);

    // Choose the right provider based on whether studentId is provided
    final revisionsAsync = studentId != null
        ? ref.watch(studentRevisionsProvider(studentId))
        : branchId != null
            ? ref.watch(branchRevisionsProvider(branchId))
            : const AsyncData(<Revision>[]);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.revisionTracking),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Summary cards
          revisionsAsync.when(
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SizedBox(
              height: 100,
              child: Center(
                child: Text('${context.l.errorLoadingStats}: $e'),
              ),
            ),
            data: (revisions) => _buildSummaryCards(revisions),
          ),

          // Filter chips
          _buildFilterChips(),

          // Revision list
          Expanded(
            child: revisionsAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    Gap.m,
                    Text('${context.l.errorLoadingRevisions}: $e'),
                    Gap.m,
                    TextButton(
                      onPressed: () {
                        _refreshProviders();
                      },
                      child: Text(context.l.retry),
                    ),
                  ],
                ),
              ),
              data: (revisions) {
                final filtered = _applyFilter(revisions);
                if (filtered.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.menu_book_outlined,
                    title: context.l.noRevisions,
                    description: context.l.noRevisionsDesc,
                  );
                }
                return _buildRevisionList(filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary Cards ──

  Widget _buildSummaryCards(List<Revision> revisions) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final dueToday = revisions.where((r) =>
        r.dueDate != null &&
        r.dueDate!.isAfter(todayStart) &&
        r.dueDate!.isBefore(todayEnd) &&
        r.status != RevisionStatus.completed).length;

    final overdue = revisions.where((r) =>
        r.dueDate != null &&
        r.dueDate!.isBefore(todayStart) &&
        r.status != RevisionStatus.completed).length;

    final weak = revisions.where((r) =>
        r.status == RevisionStatus.needsRevision ||
        (r.qualityScore != null && r.qualityScore! < 5)).length;

    final strong = revisions.where((r) =>
        r.status == RevisionStatus.completed &&
        r.qualityScore != null &&
        r.qualityScore! >= 7).length;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              label: context.l.dueToday,
              value: dueToday,
              color: AppColors.warning,
              icon: Icons.today,
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: _SummaryCard(
              label: context.l.overdueRevision,
              value: overdue,
              color: AppColors.error,
              icon: Icons.warning_amber_outlined,
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: _SummaryCard(
              label: context.l.weakRevision,
              value: weak,
              color: AppColors.needsRevision,
              icon: Icons.trending_down,
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: _SummaryCard(
              label: context.l.strongRevision,
              value: strong,
              color: AppColors.success,
              icon: Icons.check_circle_outline,
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter Chips ──

  Widget _buildFilterChips() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.symmetric(
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

  // ── Revision List ──

  Widget _buildRevisionList(List<Revision> revisions) {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshProviders();
      },
      child: ListView.builder(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        itemCount: revisions.length,
        itemBuilder: (context, index) {
          final revision = revisions[index];
          return _RevisionCard(
            revision: revision,
            onStartRevision: () => _showRevisionResultSheet(revision),
            onTap: () => _showRevisionDetail(revision),
          );
        },
      ),
    );
  }

  // ── Refresh ──

  void _refreshProviders() {
    final studentId = widget.studentId;
    final branchId = ref.read(activeBranchIdProvider);
    if (studentId != null) {
      ref.invalidate(studentRevisionsProvider(studentId));
    } else if (branchId != null) {
      ref.invalidate(branchRevisionsProvider(branchId));
    }
  }

  // ── Filter Logic ──

  List<Revision> _applyFilter(List<Revision> revisions) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    return revisions.where((r) {
      return switch (_filter) {
        _FilterOption.all => true,
        _FilterOption.dueToday =>
          r.dueDate != null &&
              r.dueDate!.isAfter(todayStart) &&
              r.dueDate!.isBefore(todayStart.add(const Duration(days: 1))) &&
              r.status != RevisionStatus.completed,
        _FilterOption.overdue =>
          r.dueDate != null &&
              r.dueDate!.isBefore(todayStart) &&
              r.status != RevisionStatus.completed,
        _FilterOption.weak =>
          r.status == RevisionStatus.needsRevision ||
              (r.qualityScore != null && r.qualityScore! < 5),
        _FilterOption.strong =>
          r.status == RevisionStatus.completed &&
              r.qualityScore != null &&
              r.qualityScore! >= 7,
        _FilterOption.completed => r.status == RevisionStatus.completed,
      };
    }).toList();
  }

  // ── Revision Detail Sheet ──

  void _showRevisionDetail(Revision revision) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsetsDirectional.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Gap.l,
                Text(context.l.revisionDetailTitle, style: AppTextStyles.headlineSmall),
                Gap.m,
                _buildDetailRow(context.l.surah, '${context.l.tasmiSurah} ${revision.surahNumber}'),
                _buildDetailRow(context.l.revisionAyahs, '${revision.startAyah} - ${revision.endAyah}'),
                _buildDetailRow(context.l.status, revision.status.displayNameAr),
                _buildDetailRow(context.l.revisionPriority, revision.priority.displayNameAr),
                if (revision.dueDate != null)
                  _buildDetailRow(
                    context.l.revisionDueDate,
                    DateFormat('yyyy-MM-dd', 'ar').format(revision.dueDate!),
                  ),
                if (revision.qualityScore != null)
                  _buildDetailRow(context.l.revisionQuality, '${revision.qualityScore}/10'),
                if (revision.reviewCount != null)
                  _buildDetailRow(context.l.revisionReviewCount, revision.reviewCount.toString()),
                if (revision.lastReviewedAt != null) ...[
                  Gap.xs,
                  Text(
                    '${context.l.revisionLastReviewedLabel}: ${_formatDaysSince(context, revision.lastReviewedAt!)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (revision.notes != null && revision.notes!.isNotEmpty) ...[
                  Gap.m,
                  Text(context.l.notes, style: AppTextStyles.titleSmall),
                  Gap.s,
                  Text(revision.notes!, style: AppTextStyles.bodyMedium),
                ],
                Gap.xl,
                if (revision.status != RevisionStatus.completed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showRevisionResultSheet(revision);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(context.l.startRevision),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  // ── Revision Result Sheet (after completing) ──

  void _showRevisionResultSheet(Revision revision) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _RevisionResultSheet(
        revision: revision,
        onComplete: (result) async {
          final qualityScore = switch (result) {
            _RevisionResult.strong => 9,
            _RevisionResult.needsRepetition => 6,
            _RevisionResult.weak => 3,
          };

          try {
            await ref.read(revisionNotifierProvider.notifier).completeRevision(
                  revisionId: revision.id,
                  qualityScore: qualityScore,
                );

            // Invalidate providers to refresh data
            _refreshProviders();

            if (mounted) {
              final message = switch (result) {
                _RevisionResult.strong => context.l.revisionRegisteredStrong,
                _RevisionResult.needsRepetition => context.l.revisionRegisteredNeedsRepetition,
                _RevisionResult.weak => context.l.revisionRegisteredWeak,
              };
              final color = switch (result) {
                _RevisionResult.strong => AppColors.success,
                _RevisionResult.needsRepetition => AppColors.warning,
                _RevisionResult.weak => AppColors.error,
              };

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: color),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${context.l.errorRegisteringRevision}: $e'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        },
      ),
    );
  }

  // ── Helpers ──

  String _formatDaysSince(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return context.l.today;
    if (diff == 1) return context.l.yesterday;
    if (diff < 7) return '${context.l.revisionSince} $diff أيام';
    if (diff < 30) return '${context.l.revisionSince} ${diff ~/ 7} ${context.l.revisionWeeks}';
    return '${context.l.revisionSince} ${diff ~/ 30} ${context.l.revisionMonths}';
  }
}

// ── Summary Card Widget ──

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final int value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value.toString(),
            style: AppTextStyles.headlineMedium.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Revision Card Widget ──

class _RevisionCard extends StatelessWidget {
  const _RevisionCard({
    required this.revision,
    required this.onStartRevision,
    required this.onTap,
  });

  final Revision revision;
  final VoidCallback onStartRevision;
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

  AppBadgeVariant _statusBadgeVariant(RevisionStatus status) {
    return switch (status) {
      RevisionStatus.completed => AppBadgeVariant.success,
      RevisionStatus.overdue => AppBadgeVariant.error,
      RevisionStatus.needsRevision => AppBadgeVariant.warning,
      RevisionStatus.due => AppBadgeVariant.info,
      RevisionStatus.pending => AppBadgeVariant.neutral,
      RevisionStatus.inProgress => AppBadgeVariant.info,
    };
  }

  String _formatDaysSince(BuildContext context, DateTime? date) {
    if (date == null) return context.l.notReviewedYet;
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return context.l.today;
    if (diff == 1) return context.l.yesterday;
    if (diff < 7) return '${context.l.revisionSince} $diff أيام';
    if (diff < 30) return '${context.l.revisionSince} ${diff ~/ 7} ${context.l.revisionWeeks}';
    return '${context.l.revisionSince} ${diff ~/ 30} ${context.l.revisionMonths}';
  }

  Color _scoreColor(int? score) {
    if (score == null) return AppColors.textTertiary;
    if (score >= 7) return AppColors.success;
    if (score >= 5) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = revision.dueDate != null &&
        revision.dueDate!.isBefore(DateTime.now()) &&
        revision.status != RevisionStatus.completed;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: surah name + status badge
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(revision.status.colorValue),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getSurahName(revision.surahNumber)} ${revision.startAyah}-${revision.endAyah}',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDaysSince(context, revision.lastReviewedAt),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AppBadge(
                label: revision.status.displayNameAr,
                variant: _statusBadgeVariant(revision.status),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.m),

          // Bottom row: score + start button
          Row(
            children: [
              // Quality score
              if (revision.qualityScore != null) ...[
                Icon(Icons.star, size: 16, color: _scoreColor(revision.qualityScore)),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${revision.qualityScore}/10',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _scoreColor(revision.qualityScore),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
              ],

              // Due date
              if (revision.dueDate != null) ...[
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: isOverdue ? AppColors.error : AppColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  DateFormat('dd/MM', 'ar').format(revision.dueDate!),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isOverdue ? AppColors.error : AppColors.textSecondary,
                  ),
                ),
                if (isOverdue) ...[
                  const SizedBox(width: AppSpacing.xs),
                  AppBadge(
                    label: context.l.revisionOverdueBadge,
                    variant: AppBadgeVariant.error,
                    size: AppBadgeSize.small,
                  ),
                ],
              ],

              const Spacer(),

              // Start revision button
              if (revision.status != RevisionStatus.completed)
                TextButton.icon(
                  onPressed: onStartRevision,
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: Text(context.l.startRevision),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.m,
                      vertical: AppSpacing.xs,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Revision Result Sheet Widget ──

class _RevisionResultSheet extends StatelessWidget {
  const _RevisionResultSheet({
    required this.revision,
    required this.onComplete,
  });

  final Revision revision;
  final ValueChanged<_RevisionResult> onComplete;

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

  @override
  Widget build(BuildContext context) {
    final passage =
        '${_getSurahName(revision.surahNumber)} ${revision.startAyah}-${revision.endAyah}';

    return Container(
      padding: const EdgeInsetsDirectional.all(AppSpacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Gap.l,

          // Title
            Text(
            context.l.revisionResultTitle,
            style: AppTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Gap.s,
          Text(
            passage,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          Gap.xl,

          // Result options
          _ResultOption(
            label: context.l.revisionStrongLabel,
            description: context.l.revisionStrongDescription,
            icon: Icons.check_circle_outline,
            color: AppColors.success,
            onTap: () {
              Navigator.of(context).pop();
              onComplete(_RevisionResult.strong);
            },
          ),
          const SizedBox(height: AppSpacing.m),
          _ResultOption(
            label: context.l.revisionNeedsRepetitionLabel,
            description: context.l.revisionNeedsRepetitionDescription,
            icon: Icons.warning_amber_outlined,
            color: AppColors.warning,
            onTap: () {
              Navigator.of(context).pop();
              onComplete(_RevisionResult.needsRepetition);
            },
          ),
          const SizedBox(height: AppSpacing.m),
          _ResultOption(
            label: context.l.revisionWeakLabel,
            description: context.l.revisionWeakDescription,
            icon: Icons.error_outline,
            color: AppColors.error,
            onTap: () {
              Navigator.of(context).pop();
              onComplete(_RevisionResult.weak);
            },
          ),
          const SizedBox(height: AppSpacing.l),
        ],
      ),
    );
  }
}

// ── Result Option Widget ──

class _ResultOption extends StatelessWidget {
  const _ResultOption({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsetsDirectional.all(AppSpacing.l),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

// ── Enums ──

enum _FilterOption {
  all,
  dueToday,
  overdue,
  weak,
  strong,
  completed;

  String label(BuildContext context) => switch (this) {
        all => context.l.all,
        dueToday => context.l.dueToday,
        overdue => context.l.overdueRevision,
        weak => context.l.weakRevision,
        strong => context.l.strongRevision,
        completed => context.l.completedRevision,
      };
}

enum _RevisionResult {
  strong,
  needsRepetition,
  weak;
}
