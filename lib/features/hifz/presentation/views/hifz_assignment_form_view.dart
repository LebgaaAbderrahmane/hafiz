import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/hifz_assignment.dart';
import '../../domain/repositories/hifz_assignment_provider.dart';

/// Hifz assignment create/edit view.
class HifzAssignmentFormView extends ConsumerStatefulWidget {
  final String? assignmentId;
  final String? studentId;
  final String? teacherId;
  final String? classId;
  final String? branchId;

  const HifzAssignmentFormView({
    super.key,
    this.assignmentId,
    this.studentId,
    this.teacherId,
    this.classId,
    this.branchId,
  });

  bool get isEditing => assignmentId != null;

  @override
  ConsumerState<HifzAssignmentFormView> createState() => _HifzAssignmentFormViewState();
}

class _HifzAssignmentFormViewState extends ConsumerState<HifzAssignmentFormView> {
  final _formKey = GlobalKey<FormState>();

  late AssignmentType _type;
  int _startSurah = 1;
  int _startAyah = 1;
  int _endSurah = 1;
  int _endAyah = 7;
  DateTime? _dueDate;
  String _notes = '';
  int _qualityTarget = 80;
  bool _isLoading = false;

  final _notesController = TextEditingController();
  final _qualityController = TextEditingController(text: '80');

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
    _type = AssignmentType.newMemorization;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _qualityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'تعديل التعيين' : 'تعيين حفظ جديد'),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.m),
          children: [
            _buildTypeSection(),
            Gap.m,
            _buildSurahSection(),
            Gap.m,
            _buildDateSection(),
            Gap.m,
            _buildQualitySection(),
            Gap.m,
            _buildNotesSection(),
            Gap.xxl,
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نوع التعيين', style: AppTextStyles.titleMedium),
        Gap.s,
        SegmentedButton<AssignmentType>(
          segments: const [
            ButtonSegment(
              value: AssignmentType.newMemorization,
              label: Text('حفظ جديد'),
              icon: Icon(Icons.bookmark_add_outlined),
            ),
            ButtonSegment(
              value: AssignmentType.revision,
              label: Text('مراجعة'),
              icon: Icon(Icons.refresh),
            ),
            ButtonSegment(
              value: AssignmentType.comprehensiveRevision,
              label: Text('مراجعة شاملة'),
              icon: Icon(Icons.rate_review_outlined),
            ),
          ],
          selected: {_type},
          onSelectionChanged: (selected) {
            setState(() => _type = selected.first);
          },
        ),
      ],
    );
  }

  Widget _buildSurahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الآيات', style: AppTextStyles.titleMedium),
        Gap.s,
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
                    child: Text('${i + 1}. ${_surahNames[i]}', style: AppTextStyles.bodySmall),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) setState(() => _startSurah = value);
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
                    child: Text('${i + 1}', style: AppTextStyles.bodySmall),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) setState(() => _startAyah = value);
                },
              ),
            ),
          ],
        ),
        Gap.s,
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _endSurah,
                decoration: const InputDecoration(
                  labelText: 'إلى السورة',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  _surahNames.length,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text('${i + 1}. ${_surahNames[i]}', style: AppTextStyles.bodySmall),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) setState(() => _endSurah = value);
                },
              ),
            ),
            Gap.s,
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _endAyah,
                decoration: const InputDecoration(
                  labelText: 'إلى الآية',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  300,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text('${i + 1}', style: AppTextStyles.bodySmall),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) setState(() => _endAyah = value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تاريخ التسليم', style: AppTextStyles.titleMedium),
        Gap.s,
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() => _dueDate = date);
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              _dueDate != null
                  ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                  : 'اختر التاريخ',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQualitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الجودة المطلوبة', style: AppTextStyles.titleMedium),
        Gap.s,
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _qualityTarget.toDouble(),
                min: 0,
                max: 100,
                divisions: 10,
                label: '$_qualityTarget%',
                onChanged: (value) {
                  setState(() => _qualityTarget = value.round());
                  _qualityController.text = _qualityTarget.toString();
                },
              ),
            ),
            SizedBox(
              width: 60,
              child: TextFormField(
                controller: _qualityController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null && parsed >= 0 && parsed <= 100) {
                    setState(() => _qualityTarget = parsed);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ملاحظات', style: AppTextStyles.titleMedium),
        Gap.s,
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'ملاحظات إضافية...',
          ),
          onChanged: (value) => _notes = value,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
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
            : Text(
                widget.isEditing ? 'حفظ التعديلات' : 'إنشاء التعيين',
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
              ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final assignment = HifzAssignment(
        id: widget.assignmentId ?? '',
        organizationId: '',
        branchId: widget.branchId ?? '',
        studentId: widget.studentId ?? '',
        teacherId: widget.teacherId ?? '',
        classId: widget.classId,
        startSurah: _startSurah,
        startAyah: _startAyah,
        endSurah: _endSurah,
        endAyah: _endAyah,
        type: _type,
        status: AssignmentStatus.pending,
        dueDate: _dueDate,
        notes: _notes.isEmpty ? null : _notes,
        qualityTarget: _qualityTarget,
        createdAt: DateTime.now(),
      );

      if (widget.isEditing) {
        await ref.read(hifzAssignmentNotifierProvider.notifier).updateAssignment(assignment);
      } else {
        await ref.read(hifzAssignmentNotifierProvider.notifier).createAssignment(assignment);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing ? 'تم تعديل التعيين بنجاح' : 'تم إنشاء التعيين بنجاح',
            ),
          ),
        );
      }
    } catch (e, st) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التعيين'),
        content: const Text('هل أنت متأكد من حذف هذا التعيين؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(hifzAssignmentNotifierProvider.notifier)
                  .deleteAssignment(widget.assignmentId!);
              if (mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف التعيين')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
