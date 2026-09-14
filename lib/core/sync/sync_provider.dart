import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import 'sync_service.dart';

/// Database singleton provider.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// SyncService singleton provider.
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref.watch(databaseProvider));
});

/// Connectivity status provider.
final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none));
});

/// Pending sync count provider.
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getPendingSyncCount();
});

/// Last sync time provider.
final lastSyncTimeProvider = StateProvider<DateTime?>((ref) => null);

/// Sync state: idle, syncing, error.
enum SyncState { idle, syncing, error }

/// Current sync state provider.
final syncStateProvider = StateProvider<SyncState>((ref) => SyncState.idle);

/// Perform a full sync operation.
Future<void> performSync(WidgetRef ref) async {
  final syncService = ref.read(syncServiceProvider);
  final connectivity = ref.read(connectivityProvider);

  if (connectivity.valueOrNull != true) {
    ref.read(syncStateProvider.notifier).state = SyncState.error;
    return;
  }

  ref.read(syncStateProvider.notifier).state = SyncState.syncing;

  try {
    await syncService.syncAll();
    ref.read(lastSyncTimeProvider.notifier).state = DateTime.now();
    ref.read(syncStateProvider.notifier).state = SyncState.idle;
    ref.invalidate(pendingSyncCountProvider);
  } catch (e) {
    ref.read(syncStateProvider.notifier).state = SyncState.error;
  }
}
