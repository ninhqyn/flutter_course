import 'answer.dart';
class Question {
  int questionId;
  int quizId;
  String questionText;
  String questionType;
  int? points;
  int orderIndex;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Answer> answers;

  Question({
    required this.questionId,
    required this.quizId,
    required this.questionText,
    required this.questionType,
    this.points,
    required this.orderIndex,
    this.createdAt,
    this.updatedAt,
    required this.answers,
  });

  // Convert JSON to Question object
  factory Question.fromJson(Map<String, dynamic> json) {
    var answersFromJson = json['answers'] as List;
    List<Answer> answersList =
    answersFromJson.map((answer) => Answer.fromJson(answer)).toList();

    return Question(
      questionId: json['questionId'],
      quizId: json['quizId'],
      questionText: json['questionText'],
      questionType: json['questionType'],
      points: json['points'],
      orderIndex: json['orderIndex'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      answers: answersList,
    );
  }

  // Convert Question object to JSON
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'quizId': quizId,
      'questionText': questionText,
      'questionType': questionType,
      'points': points,
      'orderIndex': orderIndex,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}