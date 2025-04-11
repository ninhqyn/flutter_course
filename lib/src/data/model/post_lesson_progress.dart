class PostLessonProgress {
  int lessonId;
  int courseId;
  bool isCompleted;
  int lastPositionSeconds;
  int timeSpentMinutes;

  PostLessonProgress({
    required this.lessonId,
    required this.courseId,
    required this.isCompleted,
    required this.lastPositionSeconds,
    required this.timeSpentMinutes,
  });

  factory PostLessonProgress.fromJson(Map<String, dynamic> json) {
    return PostLessonProgress(
      lessonId: json['lessonId'],
      courseId: json['courseId'],
      isCompleted: json['isCompleted'],
      lastPositionSeconds: json['lastPositionSeconds'],
      timeSpentMinutes: json['timeSpentMinutes'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'courseId': courseId,
      'isCompleted': isCompleted,
      'lastPositionSeconds': lastPositionSeconds,
      'timeSpentMinutes': timeSpentMinutes,
    };
  }
}
