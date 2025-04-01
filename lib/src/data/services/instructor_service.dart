import 'package:dio/dio.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/shared/models/instructor.dart';

class InstructorService {
  final Dio _dio;

  InstructorService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<Instructor>> getAllInstructorByCourseId(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.instructorCourse}/$courseId');

      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.instructorCourse}/$courseId');

      if (response.statusCode == 200) {
        final List<dynamic> json = response.data;
        return json.map((data) => Instructor.fromJson(data)).toList();
      }

      return const <Instructor>[];
    } on DioException catch (e) {
      print('Error getting instructors: ${e.message}');
      print('Error details: ${e.response?.data}');
      return const <Instructor>[];
    }
  }
}
