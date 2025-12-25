import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Toggle favorite: returns true if added, false if removed
  Future<bool> toggleFavorite(String destinationId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final favoriteRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(destinationId);

    final doc = await favoriteRef.get();

    if (doc.exists) {
      await favoriteRef.delete();
      return false;
    } else {
      await favoriteRef.set({
        'destinationId': destinationId,
        'addedAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
  }

  // Get user favorites as a stream of IDs
  Stream<List<String>> getFavoriteIds() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Check if a destination is favorited
  Stream<bool> isFavorite(String destinationId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(destinationId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}







