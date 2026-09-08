import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/button.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/core/widgets/text_field.dart';
import 'package:hafiz/features/tasmi/domain/entities/tasmi_session.dart';
import 'package:hafiz/features/tasmi/domain/repositories/tasmi_provider.dart';

/// Quick Tasmi' Evaluation Form.
///
/// Single screen for teacher to record tasmi' result after in-person recitation.
/// Designed for speed: outcome buttons are large and prominent.
class TasmiEvalView extends ConsumerStatefulWidget {
  const TasmiEvalView({
    super.key,
    required this.studentId,
    required this.teacherId,
    required this.sessionId,
    this.classId,
  });

  final String studentId;
  final String teacherId;
  final String sessionId;
  final String? classId;

  @override
  ConsumerState<TasmiEvalView> createState() => _TasmiEvalViewState();
}

class _TasmiEvalViewState extends ConsumerState<TasmiEvalView> {
  // Passage selection
  int _startSurah = 1;
  int _startAyah = 1;
  int _endSurah = 1;
  int _endAyah = 7;

  // Evaluation
  TasmiSessionType _sessionType = TasmiSessionType.newMemorization;
  TasmiOutcome? _outcome;
  int? _accuracyScore;
  int? _tajwidScore;
  int? _fluencyScore;
  String? _teacherNotes;

  // Errors
  final List<TasmiError> _errors = [];
  bool _showErrors = false;

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.tasmi.recordEvaluation),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPassageSection(),
            const SizedBox(height: 24),
            _buildSessionTypeSection(),
            const SizedBox(height: 24),
            _buildOutcomeSection(),
            const SizedBox(height: 24),
            if (_outcome != null) ...[
              _buildScoresSection(),
              const SizedBox(height: 24),
              _buildErrorsToggle(),
              if (_showErrors) ...[
                const SizedBox(height: 16),
                _buildErrorsSection(),
              ],
              const SizedBox(height: 24),
              _buildNotesSection(),
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPassageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l.tasmi.passage,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _startSurah,
                    decoration: InputDecoration(
                      labelText: context.l.tasmi.fromSurah,
                      border: const OutlineInputBorder(),
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
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _startAyah,
                    decoration: InputDecoration(
                      labelText: context.l.tasmi.fromAyah,
                      border: const OutlineInputBorder(),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _endSurah,
                    decoration: InputDecoration(
                      labelText: context.l.tasmi.toSurah,
                      border: const OutlineInputBorder(),
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
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _endAyah,
                    decoration: InputDecoration(
                      labelText: context.l.tasmi.toAyah,
                      border: const OutlineInputBorder(),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l.tasmi.sessionType,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l.tasmi.outcome,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: TasmiOutcome.values.map((outcome) {
                final isSelected = _outcome == outcome;
                final color = Color(outcome.colorValue);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _outcome = outcome),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
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
                            const SizedBox(height: 8),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l.tasmi.scores,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildScoreSlider(
              label: context.l.tasmi.accuracy,
              value: _accuracyScore,
              onChanged: (v) => setState(() => _accuracyScore = v),
            ),
            _buildScoreSlider(
              label: context.l.tasmi.tajwid,
              value: _tajwidScore,
              onChanged: (v) => setState(() => _tajwidScore = v),
            ),
            _buildScoreSlider(
              label: context.l.tasmi.fluency,
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
                color: value != null
                    ? Theme.of(context).colorScheme.primary
                    : null,
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
            ? context.l.tasmi.hideErrors
            : '${context.l.tasmi.addErrors} (${_errors.length})',
      ),
    );
  }

  Widget _buildErrorsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l.tasmi.errors,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ErrorType.values.map((type) {
                return ActionChip(
                  label: Text(type.displayNameAr),
                  onPressed: () => _addError(type),
                );
              }).toList(),
            ),
            if (_errors.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...(_errors.asMap().entries.map((entry) {
                final index = entry.key;
                final error = entry.value;
                return ListTile(
                  dense: true,
                  title: Text(error.errorType.displayNameAr),
                  subtitle: Text('Surah ${error.surahNumber}:${error.ayahNumber}'),
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
        padding: const EdgeInsets.all(16),
        child: AppTextField(
          label: context.l.tasmi.teacherNotes,
          maxLines: 3,
          onChanged: (v) => _teacherNotes = v,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return AppButton(
      label: _saving ? context.l.common.saving : context.l.tasmi.saveAndNext,
      onPressed: _saving || _outcome == null ? null : _save,
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    try {
      final result = await ref.read(tasmiRepositoryProvider).createSession(
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
          );

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.toString())),
          );
        },
        (session) async {
          // Save errors if any
          if (_errors.isNotEmpty) {
            await ref.read(tasmiRepositoryProvider).addErrors(
                  session.id,
                  errors: _errors,
                );
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l.tasmi.saved)),
            );
            Navigator.of(context).pop();
          }
        },
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
