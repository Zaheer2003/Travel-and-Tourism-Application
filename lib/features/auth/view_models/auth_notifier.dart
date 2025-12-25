import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_providers.dart';
import 'auth_state.dart';

part 'auth_notifier.g.dart';

/// Auth state notifier for handling authentication actions
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Listen to auth state changes
    ref.listen(authStateChangesProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            state = AuthState.authenticated(user);
          } else {
            state = const AuthState.unauthenticated();
          }
        },
        loading: () => state = const AuthState.loading(),
        error: (error, _) => state = AuthState.error(error.toString()),
      );
    });

    // Initial state
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      return AuthState.authenticated(currentUser);
    }
    return const AuthState.unauthenticated();
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Sign in anonymously
  Future<void> signInAnonymously() async {
    state = const AuthState.loading();
    try {
      final user = await ref.read(authRepositoryProvider).signInAnonymously();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}








