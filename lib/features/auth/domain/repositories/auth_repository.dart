import '../entities/user.dart';

/// Abstract auth repository.
///
/// Defines the contract for authentication operations.
/// Implementation talks to Supabase Auth.
abstract class AuthRepository {
  /// Get current authenticated user.
  Future<AppUser?> get currentUser;

  /// Stream of auth state changes.
  Stream<AppUser?> get authStateChanges;

  /// Sign in with email and password.
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password.
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  /// Sign out.
  Future<void> signOut();

  /// Send password reset email.
  Future<void> resetPassword({required String email});

  /// Update user profile.
  Future<AppUser> updateProfile({
    String? fullName,
    String? preferredName,
    String? avatarUrl,
    String? phone,
    String? language,
  });

  /// Get user roles for an organization.
  Future<List<UserRole>> getUserRoles({required String organizationId});

  /// Check if user has a specific role.
  Future<bool> hasRole({
    required String organizationId,
    required Role role,
  });

  /// Listen to auth state changes (for Riverpod).
  Stream<AppUser?> get onAuthStateChanged;
}
