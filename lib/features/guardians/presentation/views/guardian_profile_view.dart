import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/guardian.dart';
import '../../domain/repositories/guardian_provider.dart';

/// Guardian profile view.
class GuardianProfileView extends ConsumerWidget {
  final String guardianId;

  const GuardianProfileView({super.key, required this.guardianId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final guardianAsync = ref.watch(guardianRepositoryProvider).getGuardianById(guardianId);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.teachers ?? 'ولي الأمر'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Show edit dialog when create/edit guardian view is built
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('قريباً: تعديل بيانات ولي الأمر')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Guardian?>(
        future: guardianAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final guardian = snapshot.data;
          if (guardian == null) {
            return Center(
              child: Text('ولي الأمر غير موجود', style: AppTextStyles.bodyLarge),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, guardian),
                Gap.xl,

                // Info
                _buildInfoSection(context, guardian),
                Gap.xl,

                // Students
                _buildStudentsSection(context, ref, guardian),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Guardian guardian) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              guardian.name[0],
              style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
            ),
          ),
          Gap.m,
          Text(guardian.name, style: AppTextStyles.headlineSmall),
          Gap.xs,
          if (guardian.type != null)
            Text(
              guardian.type!.displayNameAr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Guardian guardian) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المعلومات الشخصية', style: AppTextStyles.titleMedium),
            Gap.m,
            _buildInfoRow(Icons.phone, 'الهاتف', guardian.phone),
            if (guardian.email != null && guardian.email!.isNotEmpty)
              _buildInfoRow(Icons.email, 'البريد الإلكتروني', guardian.email!),
            if (guardian.address != null && guardian.address!.isNotEmpty)
              _buildInfoRow(Icons.location_on, 'العنوان', guardian.address!),
            if (guardian.occupation != null && guardian.occupation!.isNotEmpty)
              _buildInfoRow(Icons.work, 'المهنة', guardian.occupation!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          Gap.s,
          Text('$label: ', style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          )),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildStudentsSection(BuildContext context, WidgetRef ref, Guardian guardian) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الطلاب المرتبطون', style: AppTextStyles.titleMedium),
            Gap.m,
            Center(
              child: Column(
                children: [
                  Icon(Icons.school, size: 48, color: AppColors.textHint),
                  Gap.m,
                  Text(
                    'لا يوجد طلاب مرتبطون',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
