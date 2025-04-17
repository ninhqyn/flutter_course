import 'package:learning_app/src/data/model/answer_select.dart';

class QuizResultRequest {
  final int userId;
  final int quizId;
  final List<AnswerSelect> answers;
  final int timeSpentMinutes;
  QuizResultRequest({this.userId = 0,required this.quizId, required this.answers,required this.timeSpentMinutes});

  Map<String, dynamic> toJson() {
    return {
      'userId':userId,
      'quizId': quizId,
      'timeSpentMinutes':timeSpentMinutes,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}
