import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_tourism/features/hotels/models/review.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a review
  Future<void> addReview(Review review) async {
    await _db.collection('reviews').add(review.toMap());
  }

  // Get reviews for a destination
  Stream<List<Review>> getReviews(String destinationId) {
    return _db
        .collection('reviews')
        .where('destinationId', isEqualTo: destinationId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromMap(doc.id, doc.data()))
            .toList());
  }
}







