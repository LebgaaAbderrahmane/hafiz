import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
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
        title: Text(context.l.createNotificationTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsetsDirectional.all(AppSpacing.l),
          children: [
            AppTextField(
              controller: _titleController,
              label: context.l.createNotificationLabel,
              hint: context.l.createNotificationHint,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? context.l.createNotificationTitleRequired : null,
            ),
            AppSpacing.gapLG,
            AppTextField(
              controller: _bodyController,
              label: context.l.createNotificationBody,
              hint: context.l.createNotificationBodyHint,
              maxLines: 3,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? context.l.createNotificationBodyRequired : null,
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
              label: context.l.createNotificationSendNow,
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
        Text(context.l.createNotificationType, style: AppTextStyles.label),
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
        Text(context.l.createNotificationAudience, style: AppTextStyles.label),
        AppSpacing.gapXS,
        RadioListTile<AudienceType>(
          title: Text(
            context.l.createNotificationAllParents,
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
            context.l.createNotificationSpecificClass,
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
            context.l.createNotificationSpecificStudent,
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
        Text(context.l.createNotificationSelectClass, style: AppTextStyles.label),
        AppSpacing.gapXS,
        classesAsync.when(
          data: (classes) {
            if (classes.isEmpty) {
              return Text(
                context.l.createNotificationNoClasses,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            }
            return DropdownButtonFormField<String>(
              value: _selectedClassId,
              decoration: InputDecoration(
                hintText: context.l.createNotificationClassHint,
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
            context.l.createNotificationErrorClasses,
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
        Text(context.l.createNotificationSelectStudent, style: AppTextStyles.label),
        AppSpacing.gapXS,
        studentsAsync.when(
          data: (students) {
            if (students.isEmpty) {
              return Text(
                context.l.createNotificationNoStudents,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            }
            return DropdownButtonFormField<String>(
              value: _selectedStudentId,
              decoration: InputDecoration(
                hintText: context.l.createNotificationStudentHint,
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
            context.l.createNotificationErrorStudents,
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
      _showSnackBar(context.l.createNotificationSelectClassFirst);
      return;
    }
    if (_audienceType == AudienceType.specificStudent &&
        _selectedStudentId == null) {
      _showSnackBar(context.l.createNotificationSelectStudentFirst);
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
        _showSnackBar(context.l.createNotificationSent);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('${context.l.createNotificationSendError}: $e');
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
