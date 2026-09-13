import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
            session?.sessionType.displayNameAr ?? 'تفاصيل التسميع',
          ),
          loading: () => const Text('تفاصيل التسميع'),
          error: (_, __) => const Text('تفاصيل التسميع'),
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
            return const AppErrorWidget(
              message: 'جلسة التسميع غير موجودة',
              title: 'خطأ',
            );
          }
          return _SessionContent(session: session);
        },
        loading: () => const AppLoading(
          size: AppLoadingSize.large,
          message: 'جاري التحميل...',
        ),
        error: (e, _) => AppErrorWidget(
          message: 'حدث خطأ أثناء تحميل بيانات الجلسة',
          title: 'خطأ',
          onRetry: () => ref.invalidate(tasmiSessionProvider(sessionId)),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الجلسة'),
        content: const Text('هل أنت متأكد من حذف هذه الجلسة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'حذف',
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
          _buildStudentInfoCard(),
          Gap.l,
          _buildPassageCard(),
          Gap.l,
          _buildOutcomeBadge(),
          Gap.l,
          _buildScoresSection(),
          if (session.errors.isNotEmpty) ...[
            Gap.l,
            _buildErrorsSection(),
          ],
          if (session.teacherNotes != null &&
              session.teacherNotes!.isNotEmpty) ...[
            Gap.l,
            _buildNotesSection(),
          ],
          Gap.l,
          _buildRecordedDate(),
          const SizedBox(height: AppSpacing.xxxxl),
        ],
      ),
    );
  }

  Widget _buildStudentInfoCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('معلومات الجلسة', style: AppTextStyles.titleMedium),
          Gap.m,
          _infoRow('رقم الطالب', session.studentId),
          Gap.s,
          _infoRow('رقم المعلم', session.teacherId),
          Gap.s,
          _infoRow('رقم الحصة', session.sessionId),
          if (session.classId != null) ...[
            Gap.s,
            _infoRow('رقم الفصل', session.classId!),
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

  Widget _buildPassageCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('القرآن', style: AppTextStyles.titleMedium),
          Gap.m,
          Row(
            children: [
              Expanded(
                child: _passageTile(
                  label: 'من',
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
                  label: 'إلى',
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
            'سورة $surah:$ayah',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOutcomeBadge() {
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
                Text('النتيجة', style: AppTextStyles.bodySmall),
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

  Widget _buildScoresSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الدرجات', style: AppTextStyles.titleMedium),
          Gap.m,
          _scoreBar('الدقة', session.accuracyScore),
          Gap.m,
          _scoreBar('التجويد', session.tajwidScore),
          Gap.m,
          _scoreBar('الطلاقة', session.fluencyScore),
          if (session.overallRating != null) ...[
            Gap.m,
            _scoreBar('التقييم العام', session.overallRating),
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

  Widget _buildErrorsSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 20),
              Gap.s,
              Text('الأخطاء', style: AppTextStyles.titleMedium),
              Gap.s,
              AppBadge(
                label: '${session.errors.length}',
                variant: AppBadgeVariant.error,
              ),
            ],
          ),
          Gap.m,
          ...session.errors.map((error) => _errorTile(error)),
        ],
      ),
    );
  }

  Widget _errorTile(TasmiError error) {
    final severityColor = switch (error.severity) {
      ErrorSeverity.minor => AppColors.warning,
      ErrorSeverity.moderate => AppColors.warning,
      ErrorSeverity.major => AppColors.error,
      null => AppColors.textTertiary,
    };
    final severityLabel = switch (error.severity) {
      ErrorSeverity.minor => 'طفيف',
      ErrorSeverity.moderate => 'متوسط',
      ErrorSeverity.major => 'جسيم',
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
                  'سورة ${error.surahNumber}:${error.ayahNumber}',
                  style: AppTextStyles.bodySmall,
                ),
                if (error.wordLocation != null)
                  Text(
                    'الموضع: ${error.wordLocation}',
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

  Widget _buildNotesSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ملاحظات المعلم', style: AppTextStyles.titleMedium),
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
