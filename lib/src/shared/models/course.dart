import 'category.dart';  // Đảm bảo bạn import class Category ở đây
import 'instructor.dart';  // Đảm bảo bạn import class Instructor ở đây

class Course {
  final int courseId;
  final int templateId;
  final Category category;
  final String courseName;
  final String description;
  final double price;
  final double discountPercentage;
  final String? thumbnailUrl;
  final int durationHours;
  final String difficultyLevel;
  final bool isFeatured;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.courseId,
    required this.templateId,
    required this.category,
    required this.courseName,
    required this.description,
    required this.price,
    required this.discountPercentage,
    this.thumbnailUrl,
    required this.durationHours,
    required this.difficultyLevel,
    required this.isFeatured,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,

  });

  // fromJson
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      templateId: json['templateId'],
      category: Category.fromJson(json['category']),
      courseName: json['courseName'],
      description: json['description'],
      price: json['price'],
      discountPercentage: json['discountPercentage'],
      thumbnailUrl: json['thumbnailUrl'],
      durationHours: json['durationHours'],
      difficultyLevel: json['difficultyLevel'],
      isFeatured: json['isFeatured'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'templateId': templateId,
      'category': category.toJson(),
      'courseName': courseName,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'thumbnailUrl': thumbnailUrl,
      'durationHours': durationHours,
      'difficultyLevel': difficultyLevel,
      'isFeatured': isFeatured,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),

    };
  }
}
