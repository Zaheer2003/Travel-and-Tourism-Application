import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_tourism/features/bookings/models/hotel_booking.dart';

class HotelBookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new hotel booking
  Future<void> createHotelBooking(HotelBooking booking) async {
    try {
      await _db.collection('hotelBookings').add(booking.toMap());
    } catch (e) {
      print('Error creating hotel booking: $e');
      rethrow;
    }
  }

  // Get all hotel bookings for the current user
  Stream<List<HotelBooking>> getUserHotelBookings() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _db
        .collection('hotelBookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => HotelBooking.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Get hotel bookings by status
  Stream<List<HotelBooking>> getHotelBookingsByStatus(String status) {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _db
        .collection('hotelBookings')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => HotelBooking.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Update hotel booking status
  Future<void> updateHotelBookingStatus(String bookingId, String newStatus) async {
    try {
      await _db.collection('hotelBookings').doc(bookingId).update({
        'status': newStatus,
      });
    } catch (e) {
      print('Error updating hotel booking status: $e');
      rethrow;
    }
  }

  // Cancel hotel booking
  Future<void> cancelHotelBooking(String bookingId) async {
    await updateHotelBookingStatus(bookingId, 'Cancelled');
  }

  // Get a specific hotel booking
  Future<HotelBooking?> getHotelBooking(String bookingId) async {
    try {
      final doc = await _db.collection('hotelBookings').doc(bookingId).get();
      if (doc.exists) {
        return HotelBooking.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting hotel booking: $e');
      return null;
    }
  }

  // Delete hotel booking
  Future<void> deleteHotelBooking(String bookingId) async {
    try {
      await _db.collection('hotelBookings').doc(bookingId).delete();
    } catch (e) {
      print('Error deleting hotel booking: $e');
      rethrow;
    }
  }
}







