import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double pricePerNight;
  final double rating;
  final List<String> amenities;
  final String description;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.pricePerNight,
    required this.rating,
    required this.amenities,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'pricePerNight': pricePerNight,
      'rating': rating,
      'amenities': amenities,
      'description': description,
    };
  }

  factory Hotel.fromFirestore(Map<String, dynamic> map, String id) {
    return Hotel(
      id: id,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      pricePerNight: (map['pricePerNight'] ?? 0.0).toDouble(),
      rating: (map['rating'] ?? 0.0).toDouble(),
      amenities: List<String>.from(map['amenities'] ?? []),
      description: map['description'] ?? '',
    );
  }
}







