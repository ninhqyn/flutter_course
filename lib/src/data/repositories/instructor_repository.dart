
import 'package:learning_app/src/data/services/instructor_service.dart';
import 'package:learning_app/src/shared/models/instructor.dart';

class InstructorRepository{
  final InstructorService instructorService;
  InstructorRepository({
    required this.instructorService
  });
  Future<List<Instructor>> getAllInstructorByCourseId(int courseId) async{
    final results = await instructorService.getAllInstructorByCourseId(courseId);
    return results;
  }

}