import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client singleton.
///
/// Initialize in bootstrap.dart before runApp().
/// Pass secrets via --dart-define:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
class SupabaseConfig {
  SupabaseConfig._();

  static const String _supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String _supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static String get url => _supabaseUrl;
  static String get anonKey => _supabaseAnonKey;

  static bool get isConfigured =>
      _supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty;
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
    anonKey: SupabaseConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}

/// Supabase client accessor.
///
/// Use this instead of Supabase.instance.client for consistency.
SupabaseClient get supabase => Supabase.instance.client;

/// Supabase auth accessor.
GoTrueClient get supabaseAuth => Supabase.instance.client.auth;

/// Supabase database accessor.
PostgrestClient get supabaseDb => Supabase.instance.client.from;

/// Supabase storage accessor.
StorageClient get supabaseStorage => Supabase.instance.client.storage;
