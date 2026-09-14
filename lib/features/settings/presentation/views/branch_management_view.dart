import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/theme/theme.dart';
import 'package:hafiz/features/auth/domain/repositories/user_role_provider.dart';
import 'package:hafiz/features/classes/domain/repositories/branch_provider.dart';
import 'package:hafiz/features/settings/domain/repositories/settings_provider.dart';

class BranchManagementView extends ConsumerStatefulWidget {
  const BranchManagementView({super.key});

  @override
  ConsumerState<BranchManagementView> createState() =>
      _BranchManagementViewState();
}

class _BranchManagementViewState extends ConsumerState<BranchManagementView> {
  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(orgBranchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفروع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBranchDialog(context),
          ),
        ],
      ),
      body: branchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (branches) {
          if (branches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 64, color: AppColors.textTertiary),
                  Gap.l,
                  Text('لا توجد فروع',
                      style: AppTextStyles.headlineSmall
                          .copyWith(color: AppColors.textSecondary)),
                  Gap.s,
                  Text('اضغط على + لإضافة فرع جديد',
                      style: AppTextStyles.bodySmall),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(AppSpacing.m),
            itemCount: branches.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final branch = branches[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primarySurface,
                  child:
                      const Icon(Icons.location_on, color: AppColors.primary),
                ),
                title: Text(branch.name, style: AppTextStyles.bodyMedium),
                subtitle: branch.address != null
                    ? Text(branch.address!, style: AppTextStyles.bodySmall)
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditBranchDialog(context, branch),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          size: 20, color: AppColors.error),
                      onPressed: () => _confirmDelete(context, branch),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddBranchDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة فرع جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الفرع',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'الهاتف',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final orgId = ref.read(activeOrganizationIdProvider);
              if (orgId == null || nameController.text.isEmpty) return;

              await ref.read(branchManagementProvider.notifier).createBranch(
                    organizationId: orgId,
                    name: nameController.text,
                    address: addressController.text.isNotEmpty
                        ? addressController.text
                        : null,
                    phone: phoneController.text.isNotEmpty
                        ? phoneController.text
                        : null,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditBranchDialog(BuildContext context, Branch branch) {
    final nameController = TextEditingController(text: branch.name);
    final addressController =
        TextEditingController(text: branch.address ?? '');
    final phoneController = TextEditingController(text: branch.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الفرع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الفرع',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
            ),
            Gap.m,
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'الهاتف',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(branchManagementProvider.notifier).updateBranch(
                    branch.id,
                    name: nameController.text,
                    address: addressController.text.isNotEmpty
                        ? addressController.text
                        : null,
                    phone: phoneController.text.isNotEmpty
                        ? phoneController.text
                        : null,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Branch branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الفرع'),
        content: Text('هل أنت متأكد من حذف "${branch.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () async {
              await ref.read(branchManagementProvider.notifier).deleteBranch(
                    branch.id,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
