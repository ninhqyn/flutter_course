
import 'package:learning_app/src/data/model/user_course.dart';
import 'package:learning_app/src/data/services/course_service.dart';

import 'package:learning_app/src/shared/models/course.dart';

class CourseRepository{
  final CourseService courseService;

  CourseRepository({
    required this.courseService,
  });
  Future<List<Course>> getAllCourse() async{
      final results = await courseService.getAllCourse();
      return results;
  }
  Future<Course> getCourseById(int courseId) async{
    final results = await courseService.getCourseById(courseId);
    return results;
  }
  Future<List<UserCourse>> getAllUserCourse() async{
    final results = await courseService.getAllUserCourse();
    return results;
  }
  Future<List<Course>> getCourseByCategoryId(int categoryId, {int page = 1, int pageSize = 10}) async{
    final results = await courseService.getCourseByCategoryId(categoryId,page: page,pageSize: pageSize);
    return results;
  }
  Future<List<Course>> getAllCourseNew({int page = 1, int pageSize = 10}) async{
    final results = await courseService.getAllCourseNew(page: page,pageSize: pageSize);
    return results;
  }
  Future<List<Course>> getAllCourseFavorites({int page = 1, int pageSize = 10}) async{
    final results = await courseService.getAllCourseNew(page: page,pageSize: pageSize);
    return results;
  }
  Future<List<Course>> getFilterCourse(
      String keyword, {
        int page = 1,
        int pageSize = 10,
        int categoryId = 0,
        int instructorId = 0
      })   async{
    final results = await courseService.getFilterCourse(
        keyword,
        page: page,
        pageSize: pageSize,
        categoryId: categoryId,
        instructorId: instructorId);
    return results;
  }
  Future<bool> checkEnrollment(int courseId) async{
    final result = await courseService.checkEnrollment(courseId);
    return result;
  }
  Future<List<Course>> getAllCourseByInstructorId(int instructorId) async{
    final results = await courseService.getAllCourseByInstructorId(instructorId);
    return results;
  }
  Future<bool> enrollCourseFree(int courseId) async{
    final result = await courseService.enrollCourseFree(courseId);
    return result;
  }
}