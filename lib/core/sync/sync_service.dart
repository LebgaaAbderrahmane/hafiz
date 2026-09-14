import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../utils/app_logger.dart';

class SyncService {
  SyncService(this._db);

  final AppDatabase _db;

  SupabaseClient get _supabase => Supabase.instance.client;

  /// Check if device is online.
  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  /// Add an operation to the sync queue.
  Future<void> addToSyncQueue({
    required String tableName,
    required String recordId,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    await _db.insertSyncQueueEntry(
      tableName: tableName,
      recordId: recordId,
      action: action,
      payload: payload,
    );
    await AppLogger.log(
      'SYNC',
      'Queued $action on $tableName:$recordId',
    );
  }

  /// Process all pending sync queue entries.
  Future<void> processSyncQueue() async {
    final pending = await _db.getPendingSyncEntries();
    if (pending.isEmpty) return;

    await AppLogger.log('SYNC', 'Processing ${pending.length} pending entries');

    for (final entry in pending) {
      try {
        final payload = jsonDecode(entry['payload'] as String) as Map<String, dynamic>;

        switch (entry['action'] as String) {
          case 'insert':
            await _supabase.from(entry['table_name'] as String).upsert(payload);
            break;
          case 'update':
            await _supabase
                .from(entry['table_name'] as String)
                .update(payload)
                .eq('id', entry['record_id'] as String);
            break;
          case 'delete':
            await _supabase
                .from(entry['table_name'] as String)
                .delete()
                .eq('id', entry['record_id'] as String);
            break;
        }

        await _db.markSyncEntrySynced(entry['id'] as int);
        await AppLogger.log(
          'SYNC',
          'Synced ${entry['action']} on ${entry['table_name']}:${entry['record_id']}',
        );
      } catch (e, st) {
        await AppLogger.logError(
          'SYNC',
          'Failed to sync entry ${entry['id']}',
          st,
        );
      }
    }
  }

  /// Pull remote data from Supabase and cache locally.
  Future<void> pullRemoteData() async {
    try {
      await _pullStudents();
      await _pullSchedules();
    } catch (e, st) {
      await AppLogger.logError('SYNC', 'Failed to pull remote data', st);
    }
  }

  Future<void> _pullStudents() async {
    final response = await _supabase.from('students').select();
    for (final row in response) {
      await _db.insertCachedStudent(
        remoteId: row['id'] as String? ?? '',
        name: row['name'] as String? ?? '',
        branchId: row['branch_id'] as String? ?? '',
        jsonData: Map<String, dynamic>.from(row as Map),
      );
    }
  }

  Future<void> _pullSchedules() async {
    final response = await _supabase.from('schedule_sessions').select();
    for (final row in response) {
      await _db.insertCachedSchedule(
        remoteId: row['id'] as String? ?? '',
        classId: row['class_id'] as String? ?? '',
        day: row['day'] as String? ?? '',
        time: row['start_time'] as String? ?? '',
        jsonData: Map<String, dynamic>.from(row as Map),
      );
    }
  }

  /// Full sync: push local changes then pull remote.
  Future<SyncResult> syncAll() async {
    final pendingCount = await _db.getPendingSyncCount();

    await AppLogger.log('SYNC', 'Starting full sync ($pendingCount pending)');

    await processSyncQueue();
    await pullRemoteData();
    await _db.clearSyncedEntries();

    final remaining = await _db.getPendingSyncCount();
    await AppLogger.log('SYNC', 'Sync complete ($remaining remaining)');

    return SyncResult(
      pushedCount: pendingCount - remaining,
      pulledCount: 0,
      remainingCount: remaining,
      timestamp: DateTime.now(),
    );
  }

  /// Save attendance locally and queue for sync.
  Future<int> saveAttendanceLocally({
    required String studentId,
    required String classId,
    String? sessionId,
    required DateTime date,
    required String status,
  }) async {
    final id = await _db.insertCachedAttendance(
      studentId: studentId,
      classId: classId,
      sessionId: sessionId,
      date: date,
      status: status,
    );

    await addToSyncQueue(
      tableName: 'attendance',
      recordId: id.toString(),
      action: 'insert',
      payload: {
        'student_id': studentId,
        'class_id': classId,
        'session_id': sessionId,
        'date': date.toIso8601String(),
        'status': status,
      },
    );

    return id;
  }

  /// Save tasmi session locally and queue for sync.
  Future<int> saveTasmiSessionLocally({
    required String studentId,
    required String passage,
    required String outcome,
    required Map<String, dynamic> fullData,
  }) async {
    final id = await _db.insertCachedTasmiSession(
      studentId: studentId,
      passage: passage,
      outcome: outcome,
      jsonData: fullData,
    );

    await addToSyncQueue(
      tableName: 'tasmi_sessions',
      recordId: id.toString(),
      action: 'insert',
      payload: fullData,
    );

    return id;
  }
}

class SyncResult {
  const SyncResult({
    required this.pushedCount,
    required this.pulledCount,
    required this.remainingCount,
    required this.timestamp,
  });

  final int pushedCount;
  final int pulledCount;
  final int remainingCount;
  final DateTime timestamp;
}
