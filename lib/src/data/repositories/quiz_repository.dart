import 'package:flutter/cupertino.dart';
import 'package:learning_app/src/data/model/quiz_result_request.dart';
import 'package:learning_app/src/data/model/quiz_result_response.dart';
import 'package:learning_app/src/data/services/quiz_service.dart';
import 'package:learning_app/src/data/model/quiz.dart';

class QuizRepository {
  final QuizService quizService;
  QuizRepository({required this.quizService});

  Future<List<Quiz>> getAllQuizzesByCourseId(int courseId) async {
    try {

      return await quizService.getAllQuizByCourseId(courseId);
    } catch (e) {

      debugPrint('Error in QuizRepository: $e');
      return [];
    }
  }

  Future<Quiz?> getQuizById(int quizId) async {
    try {
      return await quizService.getQuizById(quizId);
    } catch (e) {
      debugPrint('Error in QuizRepository: $e');
      return null;
    }
  }
  Future<QuizResultResponse> submitQuiz(QuizResultRequest request) async {
    //try {
      return await quizService.submitQuiz(request);
    // } catch (e) {
    //   debugPrint('Error in QuizRepository: $e');
    //   throw Exception('Error to submit quiz');
    // }
  }
  Future<List<QuizResultResponse>> getAllQuizResultsByQuizId(int quizId) async {
    return await quizService.getAllQuizResultsByQuizId(quizId);
  }
}
