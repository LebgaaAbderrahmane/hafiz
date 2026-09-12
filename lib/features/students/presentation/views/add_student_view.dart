import 'package:flutter/material.dart';
import "package:hafiz/core/localization/app_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hafiz/core/widgets/button.dart';
import 'package:hafiz/core/widgets/text_field.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/students/domain/entities/student.dart';
import 'package:hafiz/features/students/domain/repositories/student_provider.dart';

class AddStudentView extends ConsumerStatefulWidget {
  const AddStudentView({super.key});

  @override
  ConsumerState<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends ConsumerState<AddStudentView> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Step 1: Basic Info
  final _fullNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  Gender? _gender;
  DateTime? _dateOfBirth;
  String? _nationality;

  // Step 2: Contact
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Step 3: Education
  String? _previousQuranEducation;
  String? _currentQuranLevel;
  String? _readingLevel;
  String? _tajwidLevel;
  String? _memorizationLevel;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _preferredNameController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.addStudent),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBasicInfoStep(),
                _buildContactStep(),
                _buildEducationStep(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStepIndicator(0, context.l.stepBasicInfo),
          Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
          _buildStepIndicator(1, context.l.stepContact),
          Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
          _buildStepIndicator(2, context.l.stepEducation),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentPage >= step;
    final isCurrent = _currentPage == step;

    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          child: Text(
            '${step + 1}',
            style: TextStyle(
              color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCurrent
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l.basicInfo,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _fullNameController,
              label: context.l.fullName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l.required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _preferredNameController,
              label: context.l.preferredName,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _studentIdController,
              label: context.l.studentId,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Gender>(
              initialValue: _gender,
              decoration: InputDecoration(
                labelText: context.l.gender,
                border: const OutlineInputBorder(),
              ),
              items: Gender.values
                  .map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g.displayNameAr),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _gender = value),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(context.l.dateOfBirth),
              subtitle: Text(
                _dateOfBirth != null
                    ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                    : context.l.selectDate,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: TextEditingController(text: _nationality),
              label: context.l.nationality,
              onChanged: (value) => _nationality = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l.contactInfo,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: _phoneController,
            label: context.l.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _emailController,
            label: context.l.email,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildEducationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l.quranEducation,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _previousQuranEducation,
            decoration: InputDecoration(
              labelText: context.l.previousEducation,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: 'none', child: Text(context.l.none)),
              DropdownMenuItem(value: 'basic', child: Text(context.l.basic)),
              DropdownMenuItem(value: 'intermediate', child: Text(context.l.intermediate)),
              DropdownMenuItem(value: 'advanced', child: Text(context.l.advanced)),
            ],
            onChanged: (value) => setState(() => _previousQuranEducation = value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _currentQuranLevel,
            decoration: InputDecoration(
              labelText: context.l.currentQuranLevel,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: 'beginner', child: Text(context.l.beginner)),
              DropdownMenuItem(value: 'elementary', child: Text(context.l.elementary)),
              DropdownMenuItem(value: 'intermediate', child: Text(context.l.intermediate)),
              DropdownMenuItem(value: 'advanced', child: Text(context.l.advanced)),
              DropdownMenuItem(value: 'hafiz', child: Text(context.l.hafiz)),
            ],
            onChanged: (value) => setState(() => _currentQuranLevel = value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _readingLevel,
            decoration: InputDecoration(
              labelText: context.l.readingLevel,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: 'cant_read', child: Text(context.l.cantRead)),
              DropdownMenuItem(value: 'beginner', child: Text(context.l.beginner)),
              DropdownMenuItem(value: 'intermediate', child: Text(context.l.intermediate)),
              DropdownMenuItem(value: 'advanced', child: Text(context.l.advanced)),
            ],
            onChanged: (value) => setState(() => _readingLevel = value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _tajwidLevel,
            decoration: InputDecoration(
              labelText: context.l.tajwidLevel,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: 'none', child: Text(context.l.none)),
              DropdownMenuItem(value: 'basic', child: Text(context.l.basic)),
              DropdownMenuItem(value: 'intermediate', child: Text(context.l.intermediate)),
              DropdownMenuItem(value: 'advanced', child: Text(context.l.advanced)),
            ],
            onChanged: (value) => setState(() => _tajwidLevel = value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _memorizationLevel,
            decoration: InputDecoration(
              labelText: context.l.memorizationLevel,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: 'none', child: Text(context.l.none)),
              DropdownMenuItem(value: 'juz_ama', child: Text(context.l.juzAma)),
              DropdownMenuItem(value: 'juz_2_5', child: Text(context.l.juz2to5)),
              DropdownMenuItem(value: 'juz_6_10', child: Text(context.l.juz6to10)),
              DropdownMenuItem(value: 'juz_11_20', child: Text(context.l.juz11to20)),
              DropdownMenuItem(value: 'juz_21_30', child: Text(context.l.juz21to30)),
              DropdownMenuItem(value: 'hafiz', child: Text(context.l.hafiz)),
            ],
            onChanged: (value) => setState(() => _memorizationLevel = value),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: AppButton(
                label: context.l.previous,
                variant: AppButtonVariant.outlined,
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  setState(() => _currentPage--);
                },
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              label: _currentPage == 2
                  ? context.l.save
                  : context.l.next,
              onPressed: _currentPage == 2 ? _submit : _nextStep,
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentPage == 0 && !_formKey.currentState!.validate()) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage++);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2010),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _dateOfBirth = date);
    }
  }

  Future<void> _submit() async {
    final orgId = ref.read(activeOrganizationIdProvider) ?? '';
    final branchId = ref.read(activeBranchIdProvider) ?? '';
    final result = await ref.read(studentRepositoryProvider).createStudent(
          organizationId: orgId,
          branchId: branchId,
          fullName: _fullNameController.text,
          studentId: _studentIdController.text.isNotEmpty
              ? _studentIdController.text
              : null,
          preferredName: _preferredNameController.text.isNotEmpty
              ? _preferredNameController.text
              : null,
          gender: _gender,
          dateOfBirth: _dateOfBirth,
          nationality: _nationality,
          phone: _phoneController.text.isNotEmpty
              ? _phoneController.text
              : null,
          email: _emailController.text.isNotEmpty
              ? _emailController.text
              : null,
          previousQuranEducation: _previousQuranEducation,
          currentQuranLevel: _currentQuranLevel,
        );

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.toString())),
        );
      },
      (student) {
        ref.read(studentsProvider.notifier).refresh();
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.studentAdded)),
        );
      },
    );
  }
}
