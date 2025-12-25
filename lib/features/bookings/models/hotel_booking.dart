import 'package:cloud_firestore/cloud_firestore.dart';

class HotelBooking {
  final String id;
  final String userId;
  final String hotelId;
  final String hotelName;
  final String hotelImage;
  final String hotelLocation;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int rooms;
  final int guests;
  final double pricePerNight;
  final double totalPrice;
  final String status; // 'Upcoming', 'Completed', 'Cancelled'
  final DateTime createdAt;
  final List<String> amenities;

  HotelBooking({
    required this.id,
    required this.userId,
    required this.hotelId,
    required this.hotelName,
    required this.hotelImage,
    required this.hotelLocation,
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.guests,
    required this.pricePerNight,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.amenities,
  });

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'hotelImage': hotelImage,
      'hotelLocation': hotelLocation,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'rooms': rooms,
      'guests': guests,
      'pricePerNight': pricePerNight,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'amenities': amenities,
    };
  }

  factory HotelBooking.fromMap(String id, Map<String, dynamic> map) {
    return HotelBooking(
      id: id,
      userId: map['userId'] ?? '',
      hotelId: map['hotelId'] ?? '',
      hotelName: map['hotelName'] ?? '',
      hotelImage: map['hotelImage'] ?? '',
      hotelLocation: map['hotelLocation'] ?? '',
      checkInDate: map['checkInDate'] is String 
          ? DateTime.parse(map['checkInDate']) 
          : (map['checkInDate'] as Timestamp).toDate(),
      checkOutDate: map['checkOutDate'] is String 
          ? DateTime.parse(map['checkOutDate']) 
          : (map['checkOutDate'] as Timestamp).toDate(),
      rooms: map['rooms'] ?? 1,
      guests: map['guests'] ?? 1,
      pricePerNight: (map['pricePerNight'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: map['status'] ?? 'Upcoming',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is String 
              ? DateTime.parse(map['createdAt']) 
              : (map['createdAt'] as Timestamp).toDate())
          : DateTime.now(),
      amenities: List<String>.from(map['amenities'] ?? []),
    );
  }
}







