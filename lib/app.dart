import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/localization.dart';
import 'core/router/app_router.dart';

/// Root app widget.
///
/// Configures theme, localization, and routing.
class HafizApp extends ConsumerWidget {
  const HafizApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Hafiz',
      debugShowCheckedModeBanner: false,

      // ── Theme ──
      theme: AppTheme.light,

      // ── Localization ──
      locale: const Locale('ar', ''),
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,

      // ── Router ──
      routerConfig: router,

      // ── Builder for RTL ──
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
