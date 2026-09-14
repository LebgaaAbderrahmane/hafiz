import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/repositories/assessment_provider.dart';

/// Create assessment view.
class CreateAssessmentView extends ConsumerStatefulWidget {
  const CreateAssessmentView({super.key});

  @override
  ConsumerState<CreateAssessmentView> createState() =>
      _CreateAssessmentViewState();
}

class _CreateAssessmentViewState extends ConsumerState<CreateAssessmentView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxScoreController = TextEditingController(text: '100');
  final _passingScoreController = TextEditingController(text: '50');
  final _notesController = TextEditingController();

  AssessmentType _type = AssessmentType.exam;
  DateTime _assessmentDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxScoreController.dispose();
    _passingScoreController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.assessmentTitle),
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
                    Text(context.l.assessmentBasicInfo, style: AppTextStyles.titleMedium),
                    Gap.m,
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: '${context.l.assessmentLabel} *',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => v?.isEmpty == true ? context.l.authRequired : null,
                    ),
                    Gap.m,
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: context.l.description,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    Gap.m,
                    DropdownButtonFormField<AssessmentType>(
                      initialValue: _type,
                      decoration: InputDecoration(
                        labelText: context.l.assessmentType,
                        border: const OutlineInputBorder(),
                      ),
                      items: AssessmentType.values.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t.displayNameAr),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _type = v);
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
                    Text(context.l.assessmentScores, style: AppTextStyles.titleMedium),
                    Gap.m,
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _maxScoreController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: context.l.assessmentMaxScore,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Gap.s,
                        Expanded(
                          child: TextFormField(
                            controller: _passingScoreController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: context.l.assessmentPassingScore,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
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
                    Text(context.l.assessmentDateAndNotes, style: AppTextStyles.titleMedium),
                    Gap.m,
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _assessmentDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() => _assessmentDate = date);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: context.l.assessmentDate,
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_assessmentDate.day}/${_assessmentDate.month}/${_assessmentDate.year}',
                        ),
                      ),
                    ),
                    Gap.m,
                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: context.l.notes,
                        border: const OutlineInputBorder(),
                      ),
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
                    : Text(context.l.assessmentSubmit),
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
      final branchId = ref.read(activeBranchIdProvider) ?? '';

      final assessment = Assessment(
        id: '',
        organizationId: orgId,
        branchId: branchId,
        teacherId: '',
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        type: _type,
        maxScore: double.tryParse(_maxScoreController.text) ?? 100,
        passingScore: double.tryParse(_passingScoreController.text) ?? 50,
        assessmentDate: _assessmentDate,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        createdAt: DateTime.now(),
      );

      await ref.read(assessmentRepositoryProvider).createAssessment(assessment);

      if (mounted) {
        ref.invalidate(branchAssessmentsProvider(branchId));
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.assessmentSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.l.error}: ${e.toString().contains('Exception') ? context.l.errorGeneric : e}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
