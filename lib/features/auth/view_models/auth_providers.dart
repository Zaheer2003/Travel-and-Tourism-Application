import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:travel_tourism/features/auth/services/firestore_datasource.dart';
import 'package:travel_tourism/features/auth/services/auth_repository.dart';
import 'package:travel_tourism/features/auth/models/user_entity.dart';
import 'package:travel_tourism/features/auth/services/auth_repository_interface.dart';

part 'auth_providers.g.dart';

/// Provider for FirebaseAuth instance
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

/// Provider for GoogleSignIn instance
@riverpod
GoogleSignIn googleSignIn(GoogleSignInRef ref) {
  return GoogleSignIn();
}

/// Provider for FirebaseFirestore instance
@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

/// Provider for FirestoreDataSource
@riverpod
FirestoreDataSource firestoreDataSource(FirestoreDataSourceRef ref) {
  return FirestoreDataSource(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
}

/// Provider for AuthRepository
@riverpod
IAuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
    firestoreDataSource: ref.watch(firestoreDataSourceProvider),
  );
}

/// Provider for auth state changes stream
@riverpod
Stream<UserEntity?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

/// Provider for current user
@riverpod
UserEntity? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider to check if user is signed in
@riverpod
bool isSignedIn(IsSignedInRef ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
}


