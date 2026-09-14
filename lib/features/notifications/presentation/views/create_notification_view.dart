import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/domain/repositories/auth_provider.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../../classes/domain/repositories/class_provider.dart';
import '../../../students/domain/repositories/student_provider.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_provider.dart';

enum AudienceType { allParents, specificClass, specificStudent }

class CreateNotificationView extends ConsumerStatefulWidget {
  const CreateNotificationView({super.key});

  @override
  ConsumerState<CreateNotificationView> createState() =>
      _CreateNotificationViewState();
}

class _CreateNotificationViewState
    extends ConsumerState<CreateNotificationView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  NotificationType _selectedType = NotificationType.system;
  AudienceType _audienceType = AudienceType.allParents;
  String? _selectedClassId;
  String? _selectedStudentId;
  bool _isSending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classesAsync = ref.watch(classesProvider);
    final studentsAsync = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('إنشاء إشعار'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsetsDirectional.all(AppSpacing.l),
          children: [
            AppTextField(
              controller: _titleController,
              label: 'العنوان',
              hint: 'أدخل عنوان الإشعار',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'العنوان مطلوب' : null,
            ),
            AppSpacing.gapLG,
            AppTextField(
              controller: _bodyController,
              label: 'النص',
              hint: 'أدخل نص الإشعار',
              maxLines: 3,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'النص مطلوب' : null,
            ),
            AppSpacing.gapXL,
            _buildTypeSelector(),
            AppSpacing.gapXL,
            _buildAudienceSelector(),
            if (_audienceType == AudienceType.specificClass) ...[
              AppSpacing.gapLG,
              _buildClassDropdown(classesAsync),
            ],
            if (_audienceType == AudienceType.specificStudent) ...[
              AppSpacing.gapLG,
              _buildStudentDropdown(studentsAsync),
            ],
            const SizedBox(height: 40),
            AppButton(
              onPressed: _isSending ? null : _sendNotification,
              label: 'إرسال الآن',
              icon: Icons.send,
              isExpanded: true,
              isLoading: _isSending,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نوع الإشعار', style: AppTextStyles.label),
        AppSpacing.gapXS,
        Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: NotificationType.values.map((type) {
            final isSelected = _selectedType == type;
            return ChoiceChip(
              label: Text(type.displayNameAr),
              selected: isSelected,
              selectedColor: AppColors.primarySurface,
              labelStyle: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              onSelected: (_) => setState(() => _selectedType = type),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAudienceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الجمهور', style: AppTextStyles.label),
        AppSpacing.gapXS,
        RadioListTile<AudienceType>(
          title: Text(
            'جميع أولياء الأمور',
            style: AppTextStyles.body,
          ),
          value: AudienceType.allParents,
          groupValue: _audienceType,
          onChanged: (v) => setState(() => _audienceType = v!),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<AudienceType>(
          title: Text(
            'فصل محدد',
            style: AppTextStyles.body,
          ),
          value: AudienceType.specificClass,
          groupValue: _audienceType,
          onChanged: (v) => setState(() => _audienceType = v!),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        RadioListTile<AudienceType>(
          title: Text(
            'طالب محدد',
            style: AppTextStyles.body,
          ),
          value: AudienceType.specificStudent,
          groupValue: _audienceType,
          onChanged: (v) => setState(() => _audienceType = v!),
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
      ],
    );
  }

  Widget _buildClassDropdown(AsyncValue classesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر الفصل', style: AppTextStyles.label),
        AppSpacing.gapXS,
        classesAsync.when(
          data: (classes) {
            if (classes.isEmpty) {
              return Text(
                'لا توجد فصول متاحة',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            }
            return DropdownButtonFormField<String>(
              value: _selectedClassId,
              decoration: const InputDecoration(
                hintText: 'اختر فصلاً',
              ),
              items: classes
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedClassId = v),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(
            'خطأ في تحميل الفصول',
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentDropdown(AsyncValue studentsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر الطالب', style: AppTextStyles.label),
        AppSpacing.gapXS,
        studentsAsync.when(
          data: (students) {
            if (students.isEmpty) {
              return Text(
                'لا يوجد طلاب متاحون',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            }
            return DropdownButtonFormField<String>(
              value: _selectedStudentId,
              decoration: const InputDecoration(
                hintText: 'اختر طالباً',
              ),
              items: students
                  .map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text(s.fullName),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedStudentId = v),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(
            'خطأ في تحميل الطلاب',
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    if (_audienceType == AudienceType.specificClass &&
        _selectedClassId == null) {
      _showSnackBar('يرجى اختيار فصل');
      return;
    }
    if (_audienceType == AudienceType.specificStudent &&
        _selectedStudentId == null) {
      _showSnackBar('يرجى اختيار طالب');
      return;
    }

    setState(() => _isSending = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final orgId = ref.read(activeOrganizationIdProvider) ?? '';
      final branchId = ref.read(activeBranchIdProvider) ?? '';

      final notifier =
          ref.read(notificationNotifierProvider.notifier);

      if (_audienceType == AudienceType.allParents) {
        final students = ref.read(studentsProvider).valueOrNull ?? [];
        for (final student in students) {
          await notifier.createNotification(
            organizationId: orgId,
            branchId: branchId,
            userId: student.id,
            type: _selectedType,
            title: _titleController.text.trim(),
            body: _bodyController.text.trim(),
          );
        }
      } else if (_audienceType == AudienceType.specificClass) {
        await notifier.createNotification(
          organizationId: orgId,
          branchId: branchId,
          userId: _selectedClassId!,
          type: _selectedType,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        );
      } else {
        await notifier.createNotification(
          organizationId: orgId,
          branchId: branchId,
          userId: _selectedStudentId!,
          type: _selectedType,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        );
      }

      if (mounted) {
        _showSnackBar('تم إرسال الإشعار بنجاح');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('خطأ في إرسال الإشعار: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
