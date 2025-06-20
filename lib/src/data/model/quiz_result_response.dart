class QuizResultResponse {
  final int resultId;
  final double score;
  final bool passed;
  final int totalQuestions;
  final int correctAnswers;
  final int attemptNumber;
  final DateTime submissionDate;
  final String message;
  final bool success;
  final int? certificateId;
  final bool certificateCreated;

  QuizResultResponse({
    required this.resultId,
    required this.score,
    required this.passed,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.attemptNumber,
    required this.submissionDate,
    required this.message,
    required this.success,
    this.certificateId,
    required this.certificateCreated,
  });

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    return QuizResultResponse(
      resultId: json['resultId'],
      score: (json['score'] as num).toDouble(),
      passed: json['passed'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      attemptNumber: json['attemptNumber'],
      submissionDate: DateTime.parse(json['submissionDate']),
      message: json['message'],
      success: json['success'],
      certificateId: json['certificateId'], // có thể là null
      certificateCreated: json['certificateCreated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': resultId,
      'score': score,
      'passed': passed,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'attemptNumber': attemptNumber,
      'submissionDate': submissionDate.toIso8601String(),
      'message': message,
      'success': success,
      'certificateId': certificateId,
      'certificateCreated': certificateCreated,
    };
  }
}
