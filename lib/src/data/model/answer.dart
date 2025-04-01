import 'dart:convert';

import 'question.dart';

// Answer Model
class Answer {
  int answerId;
  int questionId;
  String answerText;
  bool? isCorrect;

  String? explanation;
  DateTime? createdAt;
  DateTime? updatedAt;

  Answer({
    required this.answerId,
    required this.questionId,
    required this.answerText,
    this.isCorrect,

    this.explanation,
    this.createdAt,
    this.updatedAt,
  });

  // Convert JSON to Answer object
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answerId'],
      questionId: json['questionId'],
      answerText: json['answerText'],
      isCorrect: json['isCorrect'],
      explanation: json['explanation'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Convert Answer object to JSON
  Map<String, dynamic> toJson() {
    return {
      'answerId': answerId,
      'questionId': questionId,
      'answerText': answerText,
      'isCorrect': isCorrect,
      'explanation': explanation,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}




