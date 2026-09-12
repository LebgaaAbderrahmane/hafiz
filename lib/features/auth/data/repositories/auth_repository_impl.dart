import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:hafiz/features/auth/domain/entities/user.dart';
import 'package:hafiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:hafiz/core/errors/exceptions.dart';

/// Supabase auth repository implementation.
///
/// Maps Supabase GoTrue responses to AppUser entities.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  @override
  Future<AppUser?> get currentUser async {
    final session = _auth.currentSession;
    if (session == null) return null;
    return _mapUser(session.user);
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _auth.onAuthStateChange.map((event) {
      final session = event.session;
      if (session == null) return null;
      return _mapUser(session.user);
    });
  }

  @override
  Stream<AppUser?> get onAuthStateChanged => authStateChanges;

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AuthException(message: 'Login failed');
      }
      return _mapUser(response.user!);
    } on AuthException catch (e) {
      throw AuthException(message: e.toString());
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        phone: phone,
        data: {
          'full_name': fullName,
          'phone': phone,
        },
      );
      if (response.user == null) {
        throw const AuthException(message: 'Sign up failed');
      }
      return _mapUser(response.user!);
    } on AuthException catch (e) {
      throw AuthException(message: e.toString());
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<AppUser> updateProfile({
    String? fullName,
    String? preferredName,
    String? avatarUrl,
    String? phone,
    String? language,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (preferredName != null) updates['preferred_name'] = preferredName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (phone != null) updates['phone'] = phone;
      if (language != null) updates['language'] = language;

      final response = await _auth.updateUser(
        UserAttributes(data: updates),
      );

      if (response.user == null) {
        throw const AuthException(message: 'Update failed');
      }
      return _mapUser(response.user!);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<List<UserRole>> getUserRolesForUser({required String userId}) async {
    try {
      final response = await _client
          .from('user_roles')
          .select()
          .eq('user_id', userId);

      return (response as List)
          .map((json) => UserRole.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> hasRole({
    required String organizationId,
    required Role role,
  }) async {
    try {
      final response = await _client
          .from('user_roles')
          .select('id')
          .eq('organization_id', organizationId)
          .eq('role', role.name)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Map Supabase User to AppUser.
  AppUser _mapUser(User user) {
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      phone: user.phone,
      fullName: user.userMetadata?['full_name'] as String? ?? '',
      preferredName: user.userMetadata?['preferred_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      language: user.userMetadata?['language'] as String? ?? 'ar',
      isActive: true,
      createdAt: DateTime.parse(user.createdAt),
      updatedAt: user.lastSignInAt != null
          ? DateTime.parse(user.lastSignInAt!)
          : null,
    );
  }
}
