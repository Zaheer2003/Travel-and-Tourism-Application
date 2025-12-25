class Destination {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String description;
  final double price;
  final double rating;
  final List<String> categories;
  final double? lat;
  final double? lng;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.categories,
    this.lat,
    this.lng,
  });

  factory Destination.fromFirestore(Map<String, dynamic> data, String id) {
    return Destination(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      categories: List<String>.from(data['categories'] ?? []),
      lat: (data['lat'] ?? 0.0).toDouble(),
      lng: (data['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'rating': rating,
      'categories': categories,
      'lat': lat,
      'lng': lng,
    };
  }
}







