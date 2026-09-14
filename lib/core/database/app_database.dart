import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AppDatabase extends GeneratedDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await customStatement('''
            CREATE TABLE cached_students (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              remote_id TEXT NOT NULL,
              name TEXT NOT NULL,
              branch_id TEXT NOT NULL,
              json_data TEXT NOT NULL,
              last_synced TEXT,
              created_at TEXT NOT NULL DEFAULT (datetime('now'))
            )
          ''');

          await customStatement('''
            CREATE TABLE cached_schedules (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              remote_id TEXT NOT NULL,
              class_id TEXT NOT NULL,
              day TEXT NOT NULL,
              time TEXT NOT NULL,
              json_data TEXT NOT NULL,
              created_at TEXT NOT NULL DEFAULT (datetime('now'))
            )
          ''');

          await customStatement('''
            CREATE TABLE cached_attendance (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              remote_id TEXT,
              student_id TEXT NOT NULL,
              class_id TEXT NOT NULL,
              session_id TEXT,
              date TEXT NOT NULL,
              status TEXT NOT NULL,
              synced INTEGER NOT NULL DEFAULT 0,
              created_at TEXT NOT NULL DEFAULT (datetime('now'))
            )
          ''');

          await customStatement('''
            CREATE TABLE cached_tasmi_sessions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              remote_id TEXT,
              student_id TEXT NOT NULL,
              passage TEXT NOT NULL,
              outcome TEXT NOT NULL,
              json_data TEXT NOT NULL,
              synced INTEGER NOT NULL DEFAULT 0,
              created_at TEXT NOT NULL DEFAULT (datetime('now'))
            )
          ''');

          await customStatement('''
            CREATE TABLE sync_queue (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              table_name TEXT NOT NULL,
              record_id TEXT NOT NULL,
              action TEXT NOT NULL,
              payload TEXT NOT NULL,
              created_at TEXT NOT NULL DEFAULT (datetime('now')),
              synced INTEGER NOT NULL DEFAULT 0
            )
          ''');
        },
      );

  // ── Cached Students ──

  Future<int> insertCachedStudent({
    required String remoteId,
    required String name,
    required String branchId,
    required Map<String, dynamic> jsonData,
    DateTime? lastSynced,
  }) async {
    return customInsert(
      'INSERT INTO cached_students (remote_id, name, branch_id, json_data, last_synced) VALUES (?, ?, ?, ?, ?)',
      variables: [
        Variable.withString(remoteId),
        Variable.withString(name),
        Variable.withString(branchId),
        Variable.withString(jsonEncode(jsonData)),
        if (lastSynced != null) Variable.withDateTime(lastSynced),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getCachedStudents() async {
    final rows = await customSelect('SELECT * FROM cached_students').get();
    return rows.map((r) => r.data).toList();
  }

  Future<Map<String, dynamic>?> getCachedStudentByRemoteId(String remoteId) async {
    final rows = await customSelect(
      'SELECT * FROM cached_students WHERE remote_id = ?',
      variables: [Variable.withString(remoteId)],
    ).get();
    return rows.isNotEmpty ? rows.first.data : null;
  }

  Future<void> deleteCachedStudent(int id) async {
    await customStatement(
      'DELETE FROM cached_students WHERE id = ?',
      [Variable.withInt(id)],
    );
  }

  // ── Cached Schedules ──

  Future<int> insertCachedSchedule({
    required String remoteId,
    required String classId,
    required String day,
    required String time,
    required Map<String, dynamic> jsonData,
  }) async {
    return customInsert(
      'INSERT INTO cached_schedules (remote_id, class_id, day, time, json_data) VALUES (?, ?, ?, ?, ?)',
      variables: [
        Variable.withString(remoteId),
        Variable.withString(classId),
        Variable.withString(day),
        Variable.withString(time),
        Variable.withString(jsonEncode(jsonData)),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getCachedSchedules() async {
    final rows = await customSelect('SELECT * FROM cached_schedules').get();
    return rows.map((r) => r.data).toList();
  }

  Future<void> deleteCachedSchedule(int id) async {
    await customStatement(
      'DELETE FROM cached_schedules WHERE id = ?',
      [Variable.withInt(id)],
    );
  }

  // ── Cached Attendance ──

  Future<int> insertCachedAttendance({
    String? remoteId,
    required String studentId,
    required String classId,
    String? sessionId,
    required DateTime date,
    required String status,
    bool synced = false,
  }) async {
    return customInsert(
      'INSERT INTO cached_attendance (remote_id, student_id, class_id, session_id, date, status, synced) VALUES (?, ?, ?, ?, ?, ?, ?)',
      variables: [
        if (remoteId != null) Variable.withString(remoteId),
        Variable.withString(studentId),
        Variable.withString(classId),
        if (sessionId != null) Variable.withString(sessionId),
        Variable.withDateTime(date),
        Variable.withString(status),
        Variable.withBool(synced),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getCachedAttendance() async {
    final rows = await customSelect('SELECT * FROM cached_attendance').get();
    return rows.map((r) => r.data).toList();
  }

  Future<List<Map<String, dynamic>>> getUnsyncedAttendance() async {
    final rows = await customSelect(
      'SELECT * FROM cached_attendance WHERE synced = 0',
    ).get();
    return rows.map((r) => r.data).toList();
  }

  Future<void> markAttendanceSynced(int id) async {
    await customStatement(
      'UPDATE cached_attendance SET synced = 1 WHERE id = ?',
      [Variable.withInt(id)],
    );
  }

  Future<void> deleteCachedAttendance(int id) async {
    await customStatement(
      'DELETE FROM cached_attendance WHERE id = ?',
      [Variable.withInt(id)],
    );
  }

  // ── Cached Tasmi Sessions ──

  Future<int> insertCachedTasmiSession({
    String? remoteId,
    required String studentId,
    required String passage,
    required String outcome,
    required Map<String, dynamic> jsonData,
    bool synced = false,
  }) async {
    return customInsert(
      'INSERT INTO cached_tasmi_sessions (remote_id, student_id, passage, outcome, json_data, synced) VALUES (?, ?, ?, ?, ?, ?)',
      variables: [
        if (remoteId != null) Variable.withString(remoteId),
        Variable.withString(studentId),
        Variable.withString(passage),
        Variable.withString(outcome),
        Variable.withString(jsonEncode(jsonData)),
        Variable.withBool(synced),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getCachedTasmiSessions() async {
    final rows = await customSelect('SELECT * FROM cached_tasmi_sessions').get();
    return rows.map((r) => r.data).toList();
  }

  Future<List<Map<String, dynamic>>> getUnsyncedTasmiSessions() async {
    final rows = await customSelect(
      'SELECT * FROM cached_tasmi_sessions WHERE synced = 0',
    ).get();
    return rows.map((r) => r.data).toList();
  }

  Future<void> markTasmiSessionSynced(int id) async {
    await customStatement(
      'UPDATE cached_tasmi_sessions SET synced = 1 WHERE id = ?',
      [Variable.withInt(id)],
    );
  }

  Future<void> deleteCachedTasmiSession(int id) async {
    await customStatement(
      'DELETE FROM cached_tasmi_sessions WHERE id = ?',
      [Variable.withInt(id)],
    );
  }

  // ── Sync Queue ──

  Future<int> insertSyncQueueEntry({
    required String tableName,
    required String recordId,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    return customInsert(
      'INSERT INTO sync_queue (table_name, record_id, action, payload) VALUES (?, ?, ?, ?)',
      variables: [
        Variable.withString(tableName),
        Variable.withString(recordId),
        Variable.withString(action),
        Variable.withString(jsonEncode(payload)),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getPendingSyncEntries() async {
    final rows = await customSelect(
      'SELECT * FROM sync_queue WHERE synced = 0 ORDER BY created_at ASC',
    ).get();
    return rows.map((r) => r.data).toList();
  }

  Future<int> getPendingSyncCount() async {
    final rows = await customSelect(
      'SELECT COUNT(*) as count FROM sync_queue WHERE synced = 0',
    ).get();
    return (rows.first.data['count'] as int?) ?? 0;
  }

  Future<void> markSyncEntrySynced(int id) async {
    await customStatement(
      'UPDATE sync_queue SET synced = 1 WHERE id = ?',
      [Variable.withInt(id)],
    );
  }

  Future<void> clearSyncedEntries() async {
    await customStatement('DELETE FROM sync_queue WHERE synced = 1');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'hafiz', 'hafiz_drift_db.sqlite'));
    await file.parent.create(recursive: true);
    return NativeDatabase.createInBackground(file);
  });
}
