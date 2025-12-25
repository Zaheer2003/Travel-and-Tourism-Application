import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_tourism/features/auth/models/user_entity.dart';

/// Repository interface for authentication
/// This defines the contract that the data layer must implement
abstract class IAuthRepository {
  /// Sign in with Google
  Future<UserEntity?> signInWithGoogle();

  /// Sign in anonymously as guest
  Future<UserEntity?> signInAnonymously();

  /// Sign out current user
  Future<void> signOut();

  /// Stream of authentication state changes
  Stream<UserEntity?> get authStateChanges;

  /// Get current user
  UserEntity? get currentUser;

  /// Check if user is signed in
  bool get isSignedIn;
}








