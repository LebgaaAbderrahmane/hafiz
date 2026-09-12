import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/memorization_plan.dart';
import '../../domain/repositories/curriculum_provider.dart';

/// Create memorization plan view.
class CreateMemorizationPlanView extends ConsumerStatefulWidget {
  final String? studentId;
  final String? teacherId;

  const CreateMemorizationPlanView({
    super.key,
    this.studentId,
    this.teacherId,
  });

  @override
  ConsumerState<CreateMemorizationPlanView> createState() =>
      _CreateMemorizationPlanViewState();
}

class _CreateMemorizationPlanViewState
    extends ConsumerState<CreateMemorizationPlanView> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _teacherIdController = TextEditingController();

  MemorizationPriority _priority = MemorizationPriority.medium;
  int _startSurah = 1;
  int _startAyah = 1;
  int _targetSurah = 2;
  int _targetAyah = 1;
  bool _isLoading = false;

  final _surahNames = const [
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

  @override
  void initState() {
    super.initState();
    if (widget.studentId != null) {
      _studentIdController.text = widget.studentId!;
    }
    if (widget.teacherId != null) {
      _teacherIdController.text = widget.teacherId!;
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _teacherIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خطة حفظ جديدة'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.m),
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('المعلومات الأساسية', style: AppTextStyles.titleMedium),
                    Gap.m,
                    if (widget.studentId == null)
                      TextFormField(
                        controller: _studentIdController,
                        decoration: const InputDecoration(
                          labelText: 'معرف الطالب *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                      ),
                    if (widget.teacherId == null) ...[
                      Gap.m,
                      TextFormField(
                        controller: _teacherIdController,
                        decoration: const InputDecoration(
                          labelText: 'معرف المعلم *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                      ),
                    ],
                    Gap.m,
                    DropdownButtonFormField<MemorizationPriority>(
                      value: _priority,
                      decoration: const InputDecoration(
                        labelText: 'الأولوية',
                        border: OutlineInputBorder(),
                      ),
                      items: MemorizationPriority.values.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.displayNameAr),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _priority = v);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Gap.m,
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('نطاق الحفظ', style: AppTextStyles.titleMedium),
                    Gap.m,
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _startSurah,
                            decoration: const InputDecoration(
                              labelText: 'من السورة',
                              border: OutlineInputBorder(),
                            ),
                            items: List.generate(
                              _surahNames.length,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}. ${_surahNames[i]}',
                                    style: AppTextStyles.bodySmall),
                              ),
                            ),
                            onChanged: (v) {
                              if (v != null) setState(() => _startSurah = v);
                            },
                          ),
                        ),
                        Gap.s,
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _startAyah,
                            decoration: const InputDecoration(
                              labelText: 'من الآية',
                              border: OutlineInputBorder(),
                            ),
                            items: List.generate(
                              300,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}',
                                    style: AppTextStyles.bodySmall),
                              ),
                            ),
                            onChanged: (v) {
                              if (v != null) setState(() => _startAyah = v);
                            },
                          ),
                        ),
                      ],
                    ),
                    Gap.m,
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _targetSurah,
                            decoration: const InputDecoration(
                              labelText: 'إلى السورة',
                              border: OutlineInputBorder(),
                            ),
                            items: List.generate(
                              _surahNames.length,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}. ${_surahNames[i]}',
                                    style: AppTextStyles.bodySmall),
                              ),
                            ),
                            onChanged: (v) {
                              if (v != null) setState(() => _targetSurah = v);
                            },
                          ),
                        ),
                        Gap.s,
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _targetAyah,
                            decoration: const InputDecoration(
                              labelText: 'إلى الآية',
                              border: OutlineInputBorder(),
                            ),
                            items: List.generate(
                              300,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}',
                                    style: AppTextStyles.bodySmall),
                              ),
                            ),
                            onChanged: (v) {
                              if (v != null) setState(() => _targetAyah = v);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Gap.xxl,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('إنشاء الخطة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final orgId = ref.read(activeOrganizationIdProvider) ?? '';

      final result = await ref.read(curriculumRepositoryProvider).createPlan(
            studentId: _studentIdController.text,
            teacherId: _teacherIdController.text,
            organizationId: orgId,
            priority: _priority,
            startSurah: _startSurah,
            startAyah: _startAyah,
            targetSurah: _targetSurah,
            targetAyah: _targetAyah,
          );

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.toString()), backgroundColor: AppColors.error),
          );
        },
        (_) {
          ref.invalidate(studentPlansProvider(_studentIdController.text));
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إنشاء الخطة بنجاح')),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
