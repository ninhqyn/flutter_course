class UserLesson {
  int lessonId;
  int moduleId;
  String lessonName;
  String content;
  String videoUrl;
  int? durationMinutes;
  int orderIndex;
  bool isPreview;
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructor
  UserLesson({
    required this.lessonId,
    required this.moduleId,
    required this.lessonName,
    required this.content,
    required this.videoUrl,
    this.durationMinutes,
    required this.orderIndex,
    required this.isPreview,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  // Hàm fromJson
  factory UserLesson.fromJson(Map<String, dynamic> json) {
    return UserLesson(
      lessonId: json['lessonId'],
      moduleId: json['moduleId'],
      lessonName: json['lessonName'],
      content: json['content'],
      videoUrl: json['videoUrl'],
      durationMinutes: json['durationMinutes'],
      orderIndex: json['orderIndex'],
      isPreview: json['isPreview'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Hàm toJson
  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'moduleId': moduleId,
      'lessonName': lessonName,
      'content': content,
      'videoUrl': videoUrl,
      'durationMinutes': durationMinutes,
      'orderIndex': orderIndex,
      'isPreview': isPreview,
      'isCompleted':isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
