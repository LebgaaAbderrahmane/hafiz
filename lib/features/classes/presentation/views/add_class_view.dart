import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/branch_dropdown.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/repositories/class_provider.dart';

/// Add class view.
class AddClassView extends ConsumerStatefulWidget {
  const AddClassView({super.key});

  @override
  ConsumerState<AddClassView> createState() => _AddClassViewState();
}

class _AddClassViewState extends ConsumerState<AddClassView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController(text: '30');

  ClassLevel _level = ClassLevel.beginner;
  String? _selectedBranchId;
  String? _startTime;
  String? _endTime;
  final List<String> _selectedDays = [];
  bool _isLoading = false;

  final _days = const ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.addClass),
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
                    Text(context.l.addClassInfo, style: AppTextStyles.titleMedium),
                    Gap.m,
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '${context.l.addClassName} *',
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
                    DropdownButtonFormField<ClassLevel>(
                      initialValue: _level,
                      decoration: InputDecoration(
                        labelText: context.l.level,
                        border: const OutlineInputBorder(),
                      ),
                      items: ClassLevel.values.map((l) {
                        return DropdownMenuItem(
                          value: l,
                          child: Text(l.displayNameAr),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _level = v);
                      },
                    ),
                    Gap.m,
                    BranchDropdown(
                      selectedBranchId: _selectedBranchId,
                      onChanged: (v) => setState(() => _selectedBranchId = v),
                    ),
                    Gap.m,
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: context.l.addClassMaxStudents,
                        border: const OutlineInputBorder(),
                      ),
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
                    Text(context.l.addClassDays, style: AppTextStyles.titleMedium),
                    Gap.m,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _days.map((day) {
                        final selected = _selectedDays.contains(day);
                        return FilterChip(
                          label: Text(day),
                          selected: selected,
                          onSelected: (sel) {
                            setState(() {
                              if (sel) {
                                _selectedDays.add(day);
                              } else {
                                _selectedDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
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
                    Text(context.l.addClassTiming, style: AppTextStyles.titleMedium),
                    Gap.m,
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() => _startTime =
                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: context.l.startTime,
                                border: const OutlineInputBorder(),
                              ),
                              child: Text(_startTime ?? context.l.next),
                            ),
                          ),
                        ),
                        Gap.s,
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() => _endTime =
                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: context.l.endTime,
                                border: const OutlineInputBorder(),
                              ),
                              child: Text(_endTime ?? context.l.next),
                            ),
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
                    : Text(context.l.addClassSubmit),
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
      final branchId = _selectedBranchId ?? ref.read(activeBranchIdProvider) ?? '';

      if (orgId.isEmpty || branchId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l.addClassSelectBranch), backgroundColor: AppColors.error),
        );
        return;
      }

      final result = await ref.read(classRepositoryProvider).createClass(
            organizationId: orgId,
            branchId: branchId,
            name: _nameController.text,
            description: _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null,
            level: _level,
            daysOfWeek: _selectedDays,
            startTime: _startTime,
            endTime: _endTime,
            maxCapacity: int.tryParse(_capacityController.text) ?? 30,
          );

      result.fold(
        (failure) {
          debugPrint('CLASS CREATE ERROR: $failure');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${context.l.error}: $failure'), backgroundColor: AppColors.error),
          );
        },
        (_) {
          ref.read(classesProvider.notifier).refresh();
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l.addClassSuccess)),
          );
        },
      );
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
