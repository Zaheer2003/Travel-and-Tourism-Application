import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_tourism/features/auth/models/user_entity.dart';
import 'package:travel_tourism/features/auth/services/auth_repository_interface.dart';
import 'package:travel_tourism/features/auth/services/firestore_datasource.dart';

/// Implementation of IAuthRepository
/// Handles all authentication logic using Firebase
class AuthRepository implements IAuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirestoreDataSource _firestoreDataSource;

  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirestoreDataSource firestoreDataSource,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _firestoreDataSource = firestoreDataSource;

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        final userEntity = userCredential.user!.toEntity();
        // Sync user data to Firestore
        await _firestoreDataSource.updateUserData(userEntity);
        return userEntity;
      }
      
      return null;
    } catch (e, stackTrace) {
      print('Google Sign-In Error: $e');
      print('Stack Trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signInAnonymously() async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      
      if (result.user != null) {
        final userEntity = result.user!.toEntity();
        // Sync user data to Firestore
        await _firestoreDataSource.updateUserData(userEntity);
        return userEntity;
      }
      
      return null;
    } catch (e) {
      print('Anonymous Sign-In Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
    } catch (e) {
      print('Sign Out Error: $e');
      rethrow;
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _auth.authStateChanges().map((user) => user?.toEntity());
  }

  @override
  UserEntity? get currentUser {
    final user = _auth.currentUser;
    return user?.toEntity();
  }

  @override
  bool get isSignedIn => _auth.currentUser != null;
}








