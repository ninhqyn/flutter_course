import 'package:learning_app/src/shared/models/category.dart';

class UserCourse {
  int courseId;
  String courseName;
  String description;
  String? thumbnailUrl;
  String difficultyLevel;
  bool? isFeatured;
  bool? isActive;
  DateTime createdAt;
  DateTime updatedAt;
  Category category;  // Dựng đối tượng Category cho lớp Category đã có
  double progress;

  UserCourse({
    required this.courseId,
    required this.courseName,
    required this.description,
    this.thumbnailUrl,
    required this.difficultyLevel,
    this.isFeatured,
    this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.progress,
  });

  // Hàm fromJson
  factory UserCourse.fromJson(Map<String, dynamic> json) {
    return UserCourse(
      courseId: json['courseId'],
      courseName: json['courseName'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      difficultyLevel: json['difficultyLevel'],
      isFeatured: json['isFeatured'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      category: Category.fromJson(json['category']),  // Tạo đối tượng Category từ JSON
      progress: json['progress']?.toDouble() ?? 0.0,  // Đảm bảo progress là kiểu double
    );
  }

  // Hàm toJson
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'difficultyLevel': difficultyLevel,
      'isFeatured': isFeatured,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category.toJson(),  // Chuyển Category thành JSON
      'progress': progress,
    };
  }
}
