import 'package:learning_app/src/data/model/post_lesson_progress.dart';
import 'package:learning_app/src/data/services/lesson_service.dart';
class LessonRepository {
  final LessonService lessonService;
  LessonRepository({required this.lessonService});
  Future<bool> createOrUpdate(PostLessonProgress model) async {
    try {
      return await lessonService.createOrUpdateLessonProgress(model);
    } catch (e) {
      print('Error in createOrUpdate in LessonRepository: $e');
      return false;
    }
  }
}
