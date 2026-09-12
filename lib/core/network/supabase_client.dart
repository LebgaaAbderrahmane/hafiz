import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supabase client singleton.
///
/// Initialize in bootstrap.dart before runApp().
/// Pass secrets via --dart-define:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_PUBLISHABLE_KEY=...
class SupabaseConfig {
  SupabaseConfig._();

  static const String _supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://192.168.1.66:54421',
  );

  static const String _supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH',
  );

  static String get url => _supabaseUrl;
  static String get publishableKey => _supabasePublishableKey;

  static bool get isConfigured =>
      _supabaseUrl.isNotEmpty && _supabasePublishableKey.isNotEmpty;
}

/// Initialize Supabase.
///
/// Call in bootstrap() before runApp().
Future<void> initializeSupabase() async {
  if (!SupabaseConfig.isConfigured) {
    // Running without Supabase — use mock data or skip
    return;
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}

/// Supabase client accessor.
SupabaseClient get supabase => Supabase.instance.client;

/// Supabase auth accessor.
GoTrueClient get supabaseAuth => Supabase.instance.client.auth;

/// Supabase client Riverpod provider.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
