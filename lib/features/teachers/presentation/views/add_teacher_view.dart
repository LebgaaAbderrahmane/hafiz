import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/teacher_provider.dart';
import 'package:hafiz/core/widgets/branch_dropdown.dart';

/// Add teacher view.
class AddTeacherView extends ConsumerStatefulWidget {
  const AddTeacherView({super.key});

  @override
  ConsumerState<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends ConsumerState<AddTeacherView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specializationController = TextEditingController();
  final _notesController = TextEditingController();

  Gender? _gender;
  DateTime? _hireDate;
  String? _selectedBranchId;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _preferredNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.addTeacher),
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
            _buildSection(
              context.l.addTeacherBasicInfo,
              [
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: '${context.l.fullName} *',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? context.l.authRequired : null,
                ),
                Gap.m,
                TextFormField(
                  controller: _preferredNameController,
                  decoration: InputDecoration(
                    labelText: context.l.preferredName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                Gap.m,
                DropdownButtonFormField<Gender>(
                  initialValue: _gender,
                  decoration: InputDecoration(
                    labelText: context.l.gender,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: Gender.male, child: Text(context.l.editStudentMale)),
                    DropdownMenuItem(value: Gender.female, child: Text(context.l.editStudentFemale)),
                  ],
                  onChanged: (v) => setState(() => _gender = v),
                ),
                Gap.m,
                BranchDropdown(
                  selectedBranchId: _selectedBranchId,
                  onChanged: (v) => setState(() => _selectedBranchId = v),
                ),
              ],
            ),
            Gap.m,
            _buildSection(
              context.l.addTeacherContactInfo,
              [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: context.l.email,
                    border: const OutlineInputBorder(),
                  ),
                ),
                Gap.m,
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: context.l.phone,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            Gap.m,
            _buildSection(
              context.l.addTeacherProfessionalInfo,
              [
                TextFormField(
                  controller: _specializationController,
                  decoration: InputDecoration(
                    labelText: context.l.addTeacherSpecialization,
                    border: const OutlineInputBorder(),
                  ),
                ),
                Gap.m,
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _hireDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _hireDate = date);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: context.l.addTeacherHireDate,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _hireDate != null
                          ? '${_hireDate!.day}/${_hireDate!.month}/${_hireDate!.year}'
                          : context.l.addTeacherSelectDate,
                    ),
                  ),
                ),
              ],
            ),
            Gap.m,
            _buildSection(
              context.l.notes,
              [
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: context.l.addTeacherNotesHint,
                  ),
                ),
              ],
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
                    : Text(context.l.addTeacherSubmit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.titleMedium),
            Gap.m,
            ...children,
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
      final branchId =
          _selectedBranchId ?? ref.read(activeBranchIdProvider) ?? '';

      if (orgId.isEmpty || branchId.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l.addTeacherBranchRequired),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      final teacher = Teacher(
        id: '',
        organizationId: orgId,
        branchId: branchId,
        userId: '',
        fullName: _fullNameController.text,
        preferredName: _preferredNameController.text.isNotEmpty
            ? _preferredNameController.text
            : null,
        gender: _gender,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        specialization: _specializationController.text.isNotEmpty
            ? _specializationController.text
            : null,
        hireDate: _hireDate,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        createdAt: DateTime.now(),
      );

      await ref.read(teacherRepositoryProvider).createTeacher(teacher);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.addTeacherSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l.error}: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
