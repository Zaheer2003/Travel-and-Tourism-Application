import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _updateUserData(userCredential.user!);
      }
      return userCredential.user;
    } catch (e, stackTrace) {
      print('Google Sign-In Error: $e');
      print('Stack Trace: $stackTrace');
      return null;
    }
  }

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      if (result.user != null) {
        await _updateUserData(result.user!);
      }
      return result.user;
    } catch (e) {
      print('Anonymous Sign-In Error: $e');
      return null;
    }
  }

  // Sync user data to Firestore
  Future<void> _updateUserData(User user) async {
    try {
      DocumentReference userRef = _db.collection('users').doc(user.uid);

      return userRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? (user.isAnonymous ? 'Guest User' : 'User'),
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
        'isAnonymous': user.isAnonymous,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Firestore Sync Error (Check your Security Rules): $e');
      // We don't rethrow because we want the user to stay logged in even if firestore sync fails
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      if (result.user != null) {
        await _updateUserData(result.user!);
      }
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      if (result.user != null) {
        await _updateUserData(result.user!);
      }
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
