import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/tasmi_session.dart';
import '../../domain/repositories/tasmi_provider.dart';

/// Quick Tasmi' Evaluation Form.
///
/// Single screen for teacher to record tasmi' result after in-person recitation.
/// Designed for speed: outcome buttons are large and prominent.
class TasmiEvalView extends ConsumerStatefulWidget {
  final String studentId;
  final String teacherId;
  final String sessionId;
  final String? classId;

  const TasmiEvalView({
    super.key,
    required this.studentId,
    required this.teacherId,
    required this.sessionId,
    this.classId,
  });

  @override
  ConsumerState<TasmiEvalView> createState() => _TasmiEvalViewState();
}

class _TasmiEvalViewState extends ConsumerState<TasmiEvalView> {
  int _startSurah = 1;
  int _startAyah = 1;
  int _endSurah = 1;
  int _endAyah = 1;
  TasmiSessionType _sessionType = TasmiSessionType.newMemorization;
  TasmiOutcome? _outcome;
  int? _accuracyScore;
  int? _tajwidScore;
  int? _fluencyScore;
  String? _teacherNotes;
  final List<TasmiError> _errors = [];
  bool _showErrors = false;

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل التسميع'),
      ),
      body: LoadingOverlay(
        isLoading: _saving,
        message: 'جاري الحفظ...',
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPassageSection(),
              Gap.l,
              _buildSessionTypeSection(),
              Gap.l,
              _buildOutcomeSection(),
              Gap.l,
              if (_outcome != null) ...[
                _buildScoresSection(),
                Gap.l,
                _buildErrorsToggle(),
                if (_showErrors) ...[
                  Gap.m,
                  _buildErrorsSection(),
                ],
                Gap.l,
                _buildNotesSection(),
                Gap.l,
                _buildSaveButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassageSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('القرآن', style: AppTextStyles.titleMedium),
            Gap.m,
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _startSurah,
                    decoration: const InputDecoration(
                      labelText: 'من سورة',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      114,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text('${i + 1}'),
                      ),
                    ),
                    onChanged: (v) => setState(() => _startSurah = v ?? 1),
                  ),
                ),
                Gap.s,
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _startAyah,
                    decoration: const InputDecoration(
                      labelText: 'من آية',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      10,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text('${i + 1}'),
                      ),
                    ),
                    onChanged: (v) => setState(() => _startAyah = v ?? 1),
                  ),
                ),
              ],
            ),
            Gap.m,
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _endSurah,
                    decoration: const InputDecoration(
                      labelText: 'إلى سورة',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      114,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text('${i + 1}'),
                      ),
                    ),
                    onChanged: (v) => setState(() => _endSurah = v ?? 1),
                  ),
                ),
                Gap.s,
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _endAyah,
                    decoration: const InputDecoration(
                      labelText: 'إلى آية',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      10,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text('${i + 1}'),
                      ),
                    ),
                    onChanged: (v) => setState(() => _endAyah = v ?? 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTypeSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('نوع الحصة', style: AppTextStyles.titleMedium),
            Gap.m,
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: TasmiSessionType.values.map((type) {
                final isSelected = _sessionType == type;
                return ChoiceChip(
                  label: Text(type.displayNameAr),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _sessionType = type),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('النتيجة', style: AppTextStyles.titleMedium),
            Gap.m,
            Row(
              children: TasmiOutcome.values.map((outcome) {
                final isSelected = _outcome == outcome;
                final color = Color(outcome.colorValue);

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: GestureDetector(
                      onTap: () => setState(() => _outcome = outcome),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppBorderRadius.m),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : Theme.of(context).colorScheme.outline,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _getOutcomeIcon(outcome),
                              color: color,
                              size: 32,
                            ),
                            Gap.s,
                            Text(
                              outcome.displayNameAr,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getOutcomeIcon(TasmiOutcome outcome) {
    return switch (outcome) {
      TasmiOutcome.pass => Icons.check_circle,
      TasmiOutcome.needsRevision => Icons.warning_amber,
      TasmiOutcome.fail => Icons.cancel,
    };
  }

  Widget _buildScoresSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الدرجات', style: AppTextStyles.titleMedium),
            Gap.m,
            _buildScoreSlider(
              label: 'الدقة',
              value: _accuracyScore,
              onChanged: (v) => setState(() => _accuracyScore = v),
            ),
            _buildScoreSlider(
              label: 'التجويد',
              value: _tajwidScore,
              onChanged: (v) => setState(() => _tajwidScore = v),
            ),
            _buildScoreSlider(
              label: 'الطلاقة',
              value: _fluencyScore,
              onChanged: (v) => setState(() => _fluencyScore = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSlider({
    required String label,
    required int? value,
    required ValueChanged<int?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value != null ? '$value/10' : '-',
              style: TextStyle(
                color: value != null ? AppColors.primary : null,
              ),
            ),
          ],
        ),
        Slider(
          value: (value ?? 5).toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }

  Widget _buildErrorsToggle() {
    return OutlinedButton.icon(
      onPressed: () => setState(() => _showErrors = !_showErrors),
      icon: Icon(_showErrors ? Icons.expand_less : Icons.expand_more),
      label: Text(
        _showErrors
            ? 'إخفاء الأخطاء'
            : 'إضافة أخطاء (${_errors.length})',
      ),
    );
  }

  Widget _buildErrorsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الأخطاء', style: AppTextStyles.titleMedium),
            Gap.m,
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: ErrorType.values.map((type) {
                return ActionChip(
                  label: Text(type.displayNameAr),
                  onPressed: () => _addError(type),
                );
              }).toList(),
            ),
            if (_errors.isNotEmpty) ...[
              Gap.m,
              ...(_errors.asMap().entries.map((entry) {
                final index = entry.key;
                final error = entry.value;
                return ListTile(
                  dense: true,
                  title: Text(error.errorType.displayNameAr),
                  subtitle: Text('سورة ${error.surahNumber}:${error.ayahNumber}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () {
                      setState(() => _errors.removeAt(index));
                    },
                  ),
                );
              })),
            ],
          ],
        ),
      ),
    );
  }

  void _addError(ErrorType type) {
    setState(() {
      _errors.add(TasmiError(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        surahNumber: _startSurah,
        ayahNumber: _startAyah,
        errorType: type,
        severity: ErrorSeverity.moderate,
      ));
    });
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'ملاحظات المعلم',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (v) => _teacherNotes = v,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saving || _outcome == null ? null : _save,
      child: Text(_saving ? 'جاري الحفظ...' : 'حفظ وتسجيل'),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    try {
      final session = TasmiSession(
        id: '',
        organizationId: '',
        branchId: '',
        studentId: widget.studentId,
        teacherId: widget.teacherId,
        sessionId: widget.sessionId,
        classId: widget.classId,
        startSurah: _startSurah,
        startAyah: _startAyah,
        endSurah: _endSurah,
        endAyah: _endAyah,
        sessionType: _sessionType,
        outcome: _outcome!,
        accuracyScore: _accuracyScore,
        tajwidScore: _tajwidScore,
        fluencyScore: _fluencyScore,
        teacherNotes: _teacherNotes,
        recordedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final repo = ref.read(tasmiRepositoryProvider);
      await repo.createSession(session);

      if (_errors.isNotEmpty) {
        await repo.addErrors(
          sessionId: session.id,
          errors: _errors,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الحفظ بنجاح')),
        );
        Navigator.of(context).pop();
      }
    } catch (e, st) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
