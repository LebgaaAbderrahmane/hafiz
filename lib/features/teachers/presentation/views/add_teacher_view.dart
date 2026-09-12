import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/teacher_provider.dart';
import '../../../classes/domain/repositories/branch_provider.dart';

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
        title: const Text('إضافة معلم'),
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
              'المعلومات الأساسية',
              [
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                ),
                Gap.m,
                TextFormField(
                  controller: _preferredNameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم المفضل',
                    border: OutlineInputBorder(),
                  ),
                ),
                Gap.m,
                DropdownButtonFormField<Gender>(
                  initialValue: _gender,
                  decoration: const InputDecoration(
                    labelText: 'الجنس',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: Gender.male, child: Text('ذكر')),
                    DropdownMenuItem(value: Gender.female, child: Text('أنثى')),
                  ],
                  onChanged: (v) => setState(() => _gender = v),
                ),
                Gap.m,
                _buildBranchDropdown(),
              ],
            ),
            Gap.m,
            _buildSection(
              'معلومات الاتصال',
              [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    border: OutlineInputBorder(),
                  ),
                ),
                Gap.m,
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'الهاتف',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            Gap.m,
            _buildSection(
              'المعلومات المهنية',
              [
                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(
                    labelText: 'التخصص',
                    border: OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                      labelText: 'تاريخ التعيين',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _hireDate != null
                          ? '${_hireDate!.day}/${_hireDate!.month}/${_hireDate!.year}'
                          : 'اختر التاريخ',
                    ),
                  ),
                ),
              ],
            ),
            Gap.m,
            _buildSection(
              'ملاحظات',
              [
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ملاحظات إضافية...',
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
                    : const Text('إضافة المعلم'),
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

  Widget _buildBranchDropdown() {
    final branchesAsync = ref.watch(orgBranchesProvider);
    return branchesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Text('خطأ: $e'),
      data: (branches) {
        if (branches.isEmpty) {
          return const Text('لا توجد فروع', style: TextStyle(color: AppColors.error));
        }
        return DropdownButtonFormField<String>(
          initialValue: _selectedBranchId,
          decoration: const InputDecoration(
            labelText: 'الفرع *',
            border: OutlineInputBorder(),
          ),
          items: branches
              .map((b) => DropdownMenuItem(value: b.id, child: Text(b.name)))
              .toList(),
          onChanged: (v) => setState(() => _selectedBranchId = v),
          validator: (v) => v == null ? 'مطلوب' : null,
        );
      },
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
            const SnackBar(
              content: Text('يجب اختيار الفرع قبل الإضافة'),
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
          const SnackBar(content: Text('تمت إضافة المعلم بنجاح')),
        );
      }
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
