import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/drawer_icon_button.dart';
import '../../domain/entities/tasmi_session.dart';
import '../../domain/repositories/tasmi_provider.dart';

/// Detail view for a single tasmi session.
///
/// Shows full evaluation data: scores, errors, notes, and passage info.
class TasmiSessionDetailView extends ConsumerWidget {
  final String sessionId;

  const TasmiSessionDetailView({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(tasmiSessionProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        leading: const DrawerIconButton(),
        title: sessionAsync.when(
          data: (session) => Text(
            session?.sessionType.displayNameAr ?? context.l.tasmiSessionDetailTitle,
          ),
          loading: () => Text(context.l.tasmiSessionDetailTitle),
          error: (_, __) => Text(context.l.tasmiSessionDetailTitle),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: sessionAsync.when(
        data: (session) {
          if (session == null) {
            return AppErrorWidget(
              message: context.l.tasmiSessionNotFound,
              title: context.l.error,
            );
          }
          return _SessionContent(session: session);
        },
        loading: () => AppLoading(
          size: AppLoadingSize.large,
          message: context.l.tasmiLoadingSession,
        ),
        error: (e, _) => AppErrorWidget(
          message: context.l.tasmiErrorLoadingSession,
          title: context.l.error,
          onRetry: () => ref.invalidate(tasmiSessionProvider(sessionId)),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l.tasmiDeleteSession),
        content: Text(context.l.tasmiDeleteSessionConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              context.l.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionContent extends StatelessWidget {
  final TasmiSession session;

  const _SessionContent({required this.session});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStudentInfoCard(context),
          Gap.l,
          _buildPassageCard(context),
          Gap.l,
          _buildOutcomeBadge(context),
          Gap.l,
          _buildScoresSection(context),
          if (session.errors.isNotEmpty) ...[
            Gap.l,
            _buildErrorsSection(context),
          ],
          if (session.teacherNotes != null &&
              session.teacherNotes!.isNotEmpty) ...[
            Gap.l,
            _buildNotesSection(context),
          ],
          Gap.l,
          _buildRecordedDate(),
          const SizedBox(height: AppSpacing.xxxxl),
        ],
      ),
    );
  }

  Widget _buildStudentInfoCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l.tasmiSessionInfo, style: AppTextStyles.titleMedium),
          Gap.m,
          _infoRow(context.l.tasmiStudentId, session.studentId),
          Gap.s,
          _infoRow(context.l.tasmiTeacherId, session.teacherId),
          Gap.s,
          _infoRow(context.l.tasmiSessionId, session.sessionId),
          if (session.classId != null) ...[
            Gap.s,
            _infoRow(context.l.tasmiClassId, session.classId!),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildPassageCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l.quran, style: AppTextStyles.titleMedium),
          Gap.m,
          Row(
            children: [
              Expanded(
                child: _passageTile(
                  context: context,
                  label: context.l.tasmiFrom,
                  surah: session.startSurah,
                  ayah: session.startAyah,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              Expanded(
                child: _passageTile(
                  context: context,
                  label: context.l.tasmiTo,
                  surah: session.endSurah,
                  ayah: session.endAyah,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _passageTile({
    required BuildContext context,
    required String label,
    required int surah,
    required int ayah,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.radiusSM,
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption),
          Gap.xs,
          Text(
            '${context.l.tasmiSurah} $surah:$ayah',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOutcomeBadge(BuildContext context) {
    final color = Color(session.outcome.colorValue);
    final icon = switch (session.outcome) {
      TasmiOutcome.pass => Icons.check_circle,
      TasmiOutcome.needsRevision => Icons.warning_amber,
      TasmiOutcome.fail => Icons.cancel,
    };

    return AppCard(
      borderColor: color.withValues(alpha: 0.3),
      child: Row(
        children: [
          Icon(icon, color: color, size: 48),
          Gap.l,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l.tasmiResult, style: AppTextStyles.bodySmall),
                Gap.xs,
                Text(
                  session.outcome.displayNameAr,
                  style: AppTextStyles.headlineSmall.copyWith(color: color),
                ),
              ],
            ),
          ),
          AppBadge(
            label: session.sessionType.displayNameAr,
            variant: AppBadgeVariant.info,
            size: AppBadgeSize.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildScoresSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l.tasmiScores, style: AppTextStyles.titleMedium),
          Gap.m,
          _scoreBar(context.l.tasmiAccuracy, session.accuracyScore),
          Gap.m,
          _scoreBar(context.l.tasmiTajwid, session.tajwidScore),
          Gap.m,
          _scoreBar(context.l.tasmiFluency, session.fluencyScore),
          if (session.overallRating != null) ...[
            Gap.m,
            _scoreBar(context.l.tasmiOverallRating, session.overallRating),
          ],
        ],
      ),
    );
  }

  Widget _scoreBar(String label, int? score) {
    final fraction = (score ?? 0) / 10;
    final color = score != null
        ? (score >= 7
            ? AppColors.success
            : score >= 4
                ? AppColors.warning
                : AppColors.error)
        : AppColors.textTertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Text(
              score != null ? '$score/10' : '-',
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Gap.xs,
        ClipRRect(
          borderRadius: AppSpacing.radiusSM,
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 20),
              Gap.s,
              Text(context.l.tasmiErrors, style: AppTextStyles.titleMedium),
              Gap.s,
              AppBadge(
                label: '${session.errors.length}',
                variant: AppBadgeVariant.error,
              ),
            ],
          ),
          Gap.m,
          ...session.errors.map((error) => _errorTile(context, error)),
        ],
      ),
    );
  }

  Widget _errorTile(BuildContext context, TasmiError error) {
    final severityColor = switch (error.severity) {
      ErrorSeverity.minor => AppColors.warning,
      ErrorSeverity.moderate => AppColors.warning,
      ErrorSeverity.major => AppColors.error,
      null => AppColors.textTertiary,
    };
    final severityLabel = switch (error.severity) {
      ErrorSeverity.minor => context.l.tasmiErrorMinor,
      ErrorSeverity.moderate => context.l.tasmiErrorModerate,
      ErrorSeverity.major => context.l.tasmiErrorMajor,
      null => '-',
    };

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.s),
      padding: EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.radiusSM,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  error.errorType.displayNameAr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap.xs,
          Text(
            '${context.l.tasmiSurah} ${error.surahNumber}:${error.ayahNumber}',
                  style: AppTextStyles.bodySmall,
                ),
                if (error.wordLocation != null)
                  Text(
                    '${context.l.tasmiErrorLocation}: ${error.wordLocation}',
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
          ),
          AppBadge(
            label: severityLabel,
            color: severityColor,
            size: AppBadgeSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l.tasmiTeacherNotes, style: AppTextStyles.titleMedium),
          Gap.m,
          Text(
            session.teacherNotes!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordedDate() {
    final date = session.recordedAt;
    final formattedDate = DateFormat('yyyy/MM/dd', 'ar').format(date);
    final formattedTime = DateFormat('hh:mm a', 'ar').format(date);

    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 20),
          Gap.s,
          Text(formattedDate, style: AppTextStyles.bodyMedium),
          const Spacer(),
          const Icon(Icons.access_time, color: AppColors.textSecondary, size: 20),
          Gap.s,
          Text(formattedTime, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
