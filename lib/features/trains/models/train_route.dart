class TrainRoute {
  final String id;
  final String name;
  final String from;
  final String to;
  final String imageUrl;
  final String description;
  final List<String> schedule;
  final String bookingUrl;

  TrainRoute({
    required this.id,
    required this.name,
    required this.from,
    required this.to,
    required this.imageUrl,
    required this.description,
    required this.schedule,
    required this.bookingUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'from': from,
      'to': to,
      'imageUrl': imageUrl,
      'description': description,
      'schedule': schedule,
      'bookingUrl': bookingUrl,
    };
  }

  factory TrainRoute.fromFirestore(Map<String, dynamic> data, String id) {
    return TrainRoute(
      id: id,
      name: data['name'] ?? 'Route',
      from: data['from'] ?? 'Unknown',
      to: data['to'] ?? 'Unknown',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      schedule: List<String>.from(data['schedule'] ?? []),
      bookingUrl: data['bookingUrl'] ?? '',
    );
  }
}
