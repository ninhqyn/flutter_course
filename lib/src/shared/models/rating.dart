import 'package:learning_app/src/data/model/user.dart';

class Rating {
  int ratingId;
  int courseId;
  User user;  // Thay vì userId, giờ là đối tượng User
  int ratingValue;
  String reviewText;
  bool isFeatured;
  bool isApproved;
  DateTime createdAt;
  DateTime updatedAt;

  Rating({
    required this.ratingId,
    required this.courseId,
    required this.user,  // Truyền vào đối tượng User
    required this.ratingValue,
    required this.reviewText,
    required this.isFeatured,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Rating from JSON
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      ratingId: json['ratingId'] as int,
      courseId: json['courseId'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),  // Tạo đối tượng User từ JSON
      ratingValue: json['ratingValue'] as int,
      reviewText: json['reviewText'] as String,
      isFeatured: json['isFeatured'] as bool,
      isApproved: json['isApproved'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Method to convert Rating to JSON
  Map<String, dynamic> toJson() {
    return {
      'ratingId': ratingId,
      'courseId': courseId,
      'user': user.toJson(),  // Chuyển đổi đối tượng User thành JSON
      'ratingValue': ratingValue,
      'reviewText': reviewText,
      'isFeatured': isFeatured,
      'isApproved': isApproved,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
