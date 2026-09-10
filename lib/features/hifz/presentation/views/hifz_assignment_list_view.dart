import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/hifz_assignment.dart';
import '../../domain/repositories/hifz_assignment_provider.dart';

/// Hifz assignment list view.
class HifzAssignmentListView extends ConsumerStatefulWidget {
  const HifzAssignmentListView({super.key});

  @override
  ConsumerState<HifzAssignmentListView> createState() => _HifzAssignmentListViewState();
}

class _HifzAssignmentListViewState extends ConsumerState<HifzAssignmentListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AssignmentStatus? _selectedFilter;

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
    final assignmentsAsync = ref.watch(branchHifzAssignmentsProvider(''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعيينات الحفظ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _selectedFilter = switch (index) {
                0 => null,
                1 => AssignmentStatus.pending,
                2 => AssignmentStatus.inProgress,
                3 => AssignmentStatus.completed,
                _ => null,
              };
            });
          },
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'قيد الانتظار'),
            Tab(text: 'جارية'),
            Tab(text: 'مكتملة'),
          ],
        ),
      ),
      body: assignmentsAsync.when(
        data: (assignments) {
          final filtered = _selectedFilter != null
              ? assignments.where((a) => a.status == _selectedFilter).toList()
              : assignments;

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: AppColors.textHint),
                  Gap.l,
                  Text('لا توجد تعيينات', style: AppTextStyles.bodyLarge),
                  Gap.s,
                  Text(
                    'اضغط + لإنشاء تعيين حفظ جديد',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s),
            itemCount: filtered.length,
            itemBuilder: (context, index) =>
                _buildAssignmentCard(context, ref, filtered[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('خطأ: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/hifz/assignments/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAssignmentCard(
      BuildContext context, WidgetRef ref, HifzAssignment assignment) {
    final statusColor = Color(assignment.status.colorValue);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.m),
        onTap: () => context.push('/hifz/assignments/${assignment.id}/edit'),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.s,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppBorderRadius.s),
                    ),
                    child: Text(
                      assignment.status.displayNameAr,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Gap.s,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.s,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppBorderRadius.s),
                    ),
                    child: Text(
                      assignment.type.displayNameAr,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (assignment.dueDate != null)
                    Text(
                      _formatDueDate(assignment.dueDate!),
                      style: AppTextStyles.caption.copyWith(
                        color: assignment.dueDate!.isBefore(DateTime.now())
                            ? AppColors.error
                            : AppColors.textHint,
                      ),
                    ),
                ],
              ),
              Gap.m,
              Text(
                '${_getSurahName(assignment.startSurah)} ${assignment.startAyah} - ${_getSurahName(assignment.endSurah)} ${assignment.endAyah}',
                style: AppTextStyles.titleMedium,
              ),
              if (assignment.notes != null && assignment.notes!.isNotEmpty) ...[
                Gap.s,
                Text(
                  assignment.notes!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (assignment.qualityTarget != null) ...[
                Gap.s,
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 16, color: AppColors.textHint),
                    Gap.xs,
                    Text(
                      'الجودة المطلوبة: ${assignment.qualityTarget}%',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.inDays < 0) return 'متأخر ${-diff.inDays} يوم';
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'غداً';
    return DateFormat('dd/MM').format(date);
  }

  String _getSurahName(int surahNumber) {
    const surahNames = [
      'الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة', 'الأنعام',
      'الأعراف', 'الأنفال', 'التوبة', 'يونس', 'هود', 'يوسف',
      'الرعد', 'إبراهيم', 'الحجر', 'النحل', 'الإسراء', 'الكهف',
      'مريم', 'طه', 'الأنبياء', 'الحج', 'المؤمنون', 'النور',
      'الفرقان', 'الشعراء', 'النمل', 'القصص', 'العنكبوت', 'الروم',
      'لقمان', 'السجدة', 'الأحزاب', 'سبأ', 'فاطر', 'يس',
      'الصافات', 'Sad', 'الزمر', 'غافر', 'فصلت', 'الشورى',
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
    if (surahNumber >= 1 && surahNumber <= surahNames.length) {
      return surahNames[surahNumber - 1];
    }
    return 'سورة $surahNumber';
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.filter_list),
              title: const Text('تصفية حسب النوع'),
            ),
            ListTile(
              title: const Text('الكل'),
              onTap: () {
                setState(() => _selectedFilter = null);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('حفظ جديد'),
              onTap: () {
                setState(() => _selectedFilter = null);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('مراجعة'),
              onTap: () {
                setState(() => _selectedFilter = null);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
