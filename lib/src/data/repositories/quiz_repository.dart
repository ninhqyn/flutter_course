import 'package:learning_app/src/data/services/quiz_service.dart';
import 'package:learning_app/src/data/model/quiz.dart';

class QuizRepository {
  final QuizService quizService;
  QuizRepository({required this.quizService});

  Future<List<Quiz>> getAllQuizzesByCourseId(int courseId) async {
    try {

      return await quizService.getAllQuizByCourseId(courseId);
    } catch (e) {

      print('Error in QuizRepository: $e');
      return [];
    }
  }

  Future<Quiz?> getQuizById(int quizId) async {
    try {
      return await quizService.getQuizById(quizId);
    } catch (e) {
      print('Error in QuizRepository: $e');
      return null;
    }
  }
}
