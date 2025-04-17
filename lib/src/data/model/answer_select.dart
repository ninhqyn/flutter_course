class AnswerSelect {
  final int questionId;
  final int answerId;

  AnswerSelect({required this.questionId, required this.answerId});

  factory AnswerSelect.fromJson(Map<String, dynamic> json) {
    return AnswerSelect(
      questionId: json['questionId'],
      answerId: json['answerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answerId': answerId,
    };
  }
}
