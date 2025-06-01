import 'question.dart';
class Quiz {
  int quizId;
  int moduleId;
  String quizName;
  String description;
  int? passingScore;
  int? timeLimitMinutes;
  int orderIndex;
  bool? isFinal;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Question> questions;

  Quiz({
    required this.quizId,
    required this.moduleId,
    required this.quizName,
    required this.description,
    this.passingScore,
    this.timeLimitMinutes,
    this.isFinal,
    required this.orderIndex,
    this.createdAt,
    this.updatedAt,
    required this.questions,
  });

  // Convert JSON to Quiz object
  factory Quiz.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList =
    questionsFromJson.map((question) => Question.fromJson(question)).toList();

    return Quiz(
      quizId: json['quizId'],
      moduleId: json['moduleId'],
      quizName: json['quizName'],
      description: json['description'],
      passingScore: json['passingScore'],
      timeLimitMinutes: json['timeLimitMinutes'],
      orderIndex: json['orderIndex'],
      isFinal: json['isFinal'] ,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      questions: questionsList,
    );
  }

  // Convert Quiz object to JSON
  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'moduleId': moduleId,
      'quizName': quizName,
      'description': description,
      'passingScore': passingScore,
      'timeLimitMinutes': timeLimitMinutes,
      'orderIndex': orderIndex,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}