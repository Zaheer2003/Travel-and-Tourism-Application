import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_tourism/features/auth/models/user_entity.dart';

/// Data source for Firestore operations
class FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Update or create user data in Firestore
  Future<void> updateUserData(UserEntity user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);

      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
        'isAnonymous': user.isAnonymous,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Firestore Sync Error: $e');
      // Don't rethrow - we want user to stay logged in even if Firestore sync fails
    }
  }

  /// Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Delete user data from Firestore
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }
}








