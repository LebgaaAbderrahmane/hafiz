import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'core/network/supabase_client.dart';
import 'core/utils/app_logger.dart';

/// Bootstrap the app.
///
/// Initialize services, configure system settings, then run the app.
Future<void> bootstrap(Widget Function() appBuilder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── System UI ──
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // ── Preferred Orientations ──
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // ── Initialize Services ──
  await initializeSupabase();
  await AppLogger.init();
  final logPath = await AppLogger.getLogPath();
  await AppLogger.log('BOOT', 'Log file: $logPath');

  // ── Initialize Database ──
  final db = AppDatabase();
  await db.customSelect('SELECT 1').get(); // Verify DB opens
  await AppLogger.log('BOOT', 'Database initialized');

  // ── Global error handler — all errors go to log file ──
  FlutterError.onError = (details) async {
    await AppLogger.logError('FLUTTER', details.exception, details.stack);
  };
  ErrorWidget.builder = (details) => const SizedBox.shrink();

  // ── Run App ──
  runApp(
    ProviderScope(
      child: appBuilder(),
    ),
  );
}
