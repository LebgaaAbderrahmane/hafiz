import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Simple file-based logger for debugging runtime errors.
/// Logs are written to `app_debug.log` in the app's documents directory.
class AppLogger {
  static File? _file;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _file = File('${dir.path}/app_debug.log');
      // Clear old log on app start
      await _file!.writeAsString('=== App started at ${DateTime.now()} ===\n');
      _initialized = true;
    } catch (_) {
      // Fallback: no file logging
    }
  }

  static Future<void> log(String tag, String message, [Object? error]) async {
    final timestamp = DateTime.now().toIso8601String().substring(0, 23);
    final line = '[$timestamp] [$tag] $message${error != null ? ' | ERROR: $error' : ''}\n';

    // Always print to debug console
    debugPrint('$tag: $message${error != null ? ' | ERROR: $error' : ''}');

    // Also write to file
    if (_file != null) {
      try {
        await _file!.writeAsString(line, mode: FileMode.append);
      } catch (_) {}
    }
  }

  static Future<void> logError(String tag, Object error, StackTrace? stack) async {
    final buffer = StringBuffer();
    buffer.writeln('[$tag] ERROR: $error');
    if (stack != null) {
      buffer.writeln('STACK: $stack');
    }
    final text = buffer.toString();

    debugPrint(text);

    if (_file != null) {
      try {
        await _file!.writeAsString(text, mode: FileMode.append);
      } catch (_) {}
    }
  }

  static Future<String> getLogPath() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return '${dir.path}/app_debug.log';
    } catch (_) {
      return 'unknown';
    }
  }
}
