import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/sync/sync_provider.dart';
import 'package:hafiz/core/theme/theme.dart';

class SyncStatusView extends ConsumerWidget {
  const SyncStatusView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider);
    final lastSync = ref.watch(lastSyncTimeProvider);
    final isOnline = ref.watch(connectivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('حالة المزامنة'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection status
            _StatusCard(
              title: 'الاتصال',
              value: isOnline.valueOrNull == true ? 'متصل' : 'غير متصل',
              icon: isOnline.valueOrNull == true
                  ? Icons.wifi
                  : Icons.wifi_off,
              color: isOnline.valueOrNull == true
                  ? AppColors.success
                  : AppColors.error,
            ),
            const SizedBox(height: 12),

            // Pending sync count
            _StatusCard(
              title: 'عمليات المزامنة المعلقة',
              value: pendingCount.when(
                data: (count) => '$count',
                loading: () => '...',
                error: (Object e, StackTrace st) => 'خطأ',
              ),
              icon: Icons.sync,
              color: AppColors.info,
            ),
            const SizedBox(height: 12),

            // Last sync time
            _StatusCard(
              title: 'آخر مزامنة',
              value: lastSync != null
                  ? '${lastSync.hour}:${lastSync.minute.toString().padLeft(2, '0')} - ${lastSync.day}/${lastSync.month}'
                  : 'لم تتم المزامنة بعد',
              icon: Icons.access_time,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),

            // Sync button
            ElevatedButton.icon(
              onPressed: syncState == SyncState.syncing
                  ? null
                  : () => performSync(ref),
              icon: syncState == SyncState.syncing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: Text(
                syncState == SyncState.syncing ? 'جار المزامنة...' : 'مزامنة الآن',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
              ),
            ),
            if (syncState == SyncState.error) ...[
              const SizedBox(height: 8),
              Text(
                'حدث خطأ أثناء المزامنة. تحقق من اتصالك بالإنترنت.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
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
