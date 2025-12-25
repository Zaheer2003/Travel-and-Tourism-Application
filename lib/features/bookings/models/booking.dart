import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String destinationId;
  final String destinationName;
  final String destinationImage;
  final DateTime startDate;
  final DateTime endDate;
  final int guests;
  final double totalPrice;
  final String status; // 'Upcoming', 'Completed', 'Cancelled'
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.destinationId,
    required this.destinationName,
    required this.destinationImage,
    required this.startDate,
    required this.endDate,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'destinationId': destinationId,
      'destinationName': destinationName,
      'destinationImage': destinationImage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromMap(String id, Map<String, dynamic> map) {
    return Booking(
      id: id,
      userId: map['userId'] ?? '',
      destinationId: map['destinationId'] ?? '',
      destinationName: map['destinationName'] ?? '',
      destinationImage: map['destinationImage'] ?? '',
      startDate: map['startDate'] is String 
          ? DateTime.parse(map['startDate']) 
          : (map['startDate'] as Timestamp).toDate(),
      endDate: map['endDate'] is String 
          ? DateTime.parse(map['endDate']) 
          : (map['endDate'] as Timestamp).toDate(),
      guests: map['guests'] ?? 1,
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: map['status'] ?? 'Upcoming',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is String 
              ? DateTime.parse(map['createdAt']) 
              : (map['createdAt'] as Timestamp).toDate())
          : DateTime.now(),
    );
  }
}







