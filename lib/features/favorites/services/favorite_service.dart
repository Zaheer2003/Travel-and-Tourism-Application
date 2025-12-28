import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_tourism/core/services/offline_service.dart';
import 'package:travel_tourism/features/destinations/models/destination.dart';

class FavoriteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Toggle favorite: returns true if added, false if removed
  Future<bool> toggleFavorite(String destinationId, {Map<String, dynamic>? destinationData}) async {
    final user = _auth.currentUser;
    // Allow toggle even if user is offline, but we need a user ID. If cached user exists (not handled here), good.
    // Assuming auth is persistent.
    
    if (user == null) return false;

    // 1. OFFLINE / LOCAL FIRST: Check local state
    final isLocalFav = OfflineService.isFavorite(destinationId);
    
    if (isLocalFav) {
      // Remove locally
      await OfflineService.removeFavorite(destinationId);
    } else {
      // Add locally
      if (destinationData != null) {
        await OfflineService.addFavorite(destinationId, destinationData);
      }
    }

    // 2. ONLINE SYNC: Try to update Firestore
    try {
      final favoriteRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(destinationId);

      if (isLocalFav) {
        await favoriteRef.delete();
        return false; 
      } else {
        await favoriteRef.set({
          'destinationId': destinationId,
          'addedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
    } catch (e) {
      print('Offline Mode: Favorite toggled locally only ($e)');
      return !isLocalFav; 
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
        .map((snapshot) {
          final ids = snapshot.docs.map((doc) => doc.id).toList();
          // We don't have the full data here to update Hive cache fully, 
          // but we can ensure Hive matches the ID list if we only stored IDs.
          // For now, we rely on toggleFavorite and full sync.
          return ids;
        });
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

  // Get cached favorites from Hive
  List<Destination> getCachedFavorites() {
    final cachedData = OfflineService.getCachedFavorites();
    return cachedData.map((data) => Destination.fromFirestore(data, data['id'])).toList();
  }
}







