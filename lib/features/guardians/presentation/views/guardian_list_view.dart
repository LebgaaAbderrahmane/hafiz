import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/domain/repositories/user_role_provider.dart';
import '../../domain/entities/guardian.dart';
import '../../domain/repositories/guardian_provider.dart';

/// Guardian list view.
class GuardianListView extends ConsumerStatefulWidget {
  const GuardianListView({super.key});

  @override
  ConsumerState<GuardianListView> createState() => _GuardianListViewState();
}

class _GuardianListViewState extends ConsumerState<GuardianListView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final branchId = ref.watch(activeBranchIdProvider) ?? '';
    final guardiansAsync = ref.watch(branchGuardiansProvider(branchId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.teachers ?? 'أولياء الأمور'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => context.push('/guardians/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: EdgeInsets.all(AppSpacing.m),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.m),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // List
          Expanded(
            child: guardiansAsync.when(
              data: (guardians) {
                final filtered = _searchQuery.isEmpty
                    ? guardians
                    : guardians
                        .where((g) =>
                            g.name
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()) ||
                            g.phone.contains(_searchQuery))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 64, color: AppColors.textHint),
                        Gap.l,
                        Text('لا يوجد أولياء أمور', style: AppTextStyles.bodyLarge),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.m),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _buildGuardianCard(context, filtered[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuardianCard(BuildContext context, Guardian guardian) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.s),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            guardian.name[0],
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
          ),
        ),
        title: Text(guardian.name, style: AppTextStyles.titleSmall),
        subtitle: Text(
          guardian.phone,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (guardian.type != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.s),
                ),
                child: Text(
                  guardian.type!.displayNameAr,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            Gap.s,
            const Icon(Icons.chevron_left),
          ],
        ),
        onTap: () => context.push('/guardians/${guardian.id}'),
      ),
    );
  }
}
