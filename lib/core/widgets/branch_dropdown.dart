import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/classes/domain/repositories/branch_provider.dart';
import 'package:hafiz/core/theme/theme.dart';

/// Reusable branch selector dropdown that handles loading states correctly.
class BranchDropdown extends ConsumerWidget {
  const BranchDropdown({
    super.key,
    required this.selectedBranchId,
    required this.onChanged,
  });

  final String? selectedBranchId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(userRolesProvider);
    final orgId = ref.watch(activeOrganizationIdProvider);
    final branchesAsync = ref.watch(orgBranchesProvider);

    // Roles still loading — show loading indicator
    if (rolesAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      );
    }

    // No org assigned
    if (orgId == null) {
      return const Text(
        'لا يوجد مؤسسة محددة',
        style: TextStyle(color: AppColors.error),
      );
    }

    return branchesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Text('خطأ في تحميل الفروع: $e'),
      data: (branches) {
        if (branches.isEmpty) {
          return const Text(
            'لا توجد فروع متاحة',
            style: TextStyle(color: AppColors.error),
          );
        }
        return DropdownButtonFormField<String>(
          value: selectedBranchId,
          decoration: const InputDecoration(
            labelText: 'الفرع *',
            border: OutlineInputBorder(),
          ),
          items: branches
              .map((b) => DropdownMenuItem(value: b.id, child: Text(b.name)))
              .toList(),
          onChanged: onChanged,
          validator: (v) => v == null ? 'مطلوب' : null,
        );
      },
    );
  }
}
