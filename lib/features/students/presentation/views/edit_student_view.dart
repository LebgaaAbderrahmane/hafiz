import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_provider.dart';

/// Edit student view.
class EditStudentView extends ConsumerStatefulWidget {
  final String studentId;

  const EditStudentView({super.key, required this.studentId});

  @override
  ConsumerState<EditStudentView> createState() => _EditStudentViewState();
}

class _EditStudentViewState extends ConsumerState<EditStudentView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _preferredNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  Gender? _gender;
  DateTime? _dateOfBirth;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _preferredNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _preferredNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync = ref.watch(studentProvider(widget.studentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الطالب'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: studentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (student) {
          if (!_isInitialized) {
            _fullNameController.text = student.fullName;
            _preferredNameController.text = student.preferredName ?? '';
            _phoneController.text = student.phone ?? '';
            _emailController.text = student.email ?? '';
            _gender = student.gender;
            _dateOfBirth = student.dateOfBirth;
            _isInitialized = true;
          }

          return Form(
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
                          value: _gender,
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
                        Text('معلومات الاتصال', style: AppTextStyles.titleMedium),
                        Gap.m,
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'الهاتف',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Gap.m,
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            border: OutlineInputBorder(),
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
                        : const Text('حفظ التعديلات'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await ref.read(studentRepositoryProvider).updateStudent(
            widget.studentId,
            fullName: _fullNameController.text,
            preferredName: _preferredNameController.text.isNotEmpty
                ? _preferredNameController.text
                : null,
            gender: _gender,
            dateOfBirth: _dateOfBirth,
            phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
            email: _emailController.text.isNotEmpty ? _emailController.text : null,
          );

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.toString()), backgroundColor: AppColors.error),
          );
        },
        (_) {
          ref.invalidate(studentProvider(widget.studentId));
          ref.read(studentsProvider.notifier).refresh();
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تعديل الطالب بنجاح')),
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
