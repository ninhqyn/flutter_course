import 'package:learning_app/src/shared/models/lesson.dart';

class Module {
  int moduleId;
  int courseId;
  String moduleName;
  String description;
  int orderIndex;
  int? durationMinutes;
  bool isFree;
  DateTime createdAt;
  DateTime updatedAt;
  int lessonCount;
  List<Lesson> lessons;  // Giả sử bạn đã có lớp Lesson

  Module({
    required this.moduleId,
    required this.courseId,
    required this.moduleName,
    required this.description,
    required this.orderIndex,
    this.durationMinutes,
    required this.isFree,
    required this.createdAt,
    required this.updatedAt,
    required this.lessonCount,
    required this.lessons,
  });

  // Hàm fromJson
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      moduleId: json['moduleId'],
      courseId: json['courseId'],
      moduleName: json['moduleName'],
      description: json['description'],
      orderIndex: json['orderIndex'],
      durationMinutes: json['durationMinutes'],
      isFree: json['isFree'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lessonCount: json['lessonCount'],
      lessons: (json['lessons'] as List<dynamic>)
          .map((lessonJson) => Lesson.fromJson(lessonJson)) // Giả sử bạn đã có lớp Lesson
          .toList(),
    );
  }

  // Hàm toJson
  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'courseId': courseId,
      'moduleName': moduleName,
      'description': description,
      'orderIndex': orderIndex,
      'durationMinutes': durationMinutes,
      'isFree': isFree,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lessonCount': lessonCount,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(), // Giả sử bạn đã có phương thức toJson trong lớp Lesson
    };
  }
}
