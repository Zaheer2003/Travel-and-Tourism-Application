class Review {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String comment;
  final double rating;
  final DateTime date;
  final String destinationId;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.rating,
    required this.date,
    required this.destinationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'comment': comment,
      'rating': rating,
      'date': date.toIso8601String(),
      'destinationId': destinationId,
    };
  }

  factory Review.fromMap(String id, Map<String, dynamic> map) {
    return Review(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      userImage: map['userImage'] ?? '',
      comment: map['comment'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      date: DateTime.parse(map['date']),
      destinationId: map['destinationId'] ?? '',
    );
  }
}







