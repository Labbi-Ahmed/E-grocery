class ReviewModel {
  final String id;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final String date;

  const ReviewModel({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userName: json['user_name'] as String? ?? '',
      userAvatar: json['user_avatar'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }
}
