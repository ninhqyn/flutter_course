import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/data/model/user_course.dart';

import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/shared/models/course.dart';

class CourseService {
  final Dio _dio;
  final AuthRepository _authRepository;
  CourseService(AuthRepository authRepository, {Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',

  )),_authRepository = authRepository {

    // Cấu hình bỏ qua xác thực SSL
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

  }

  Future<List<UserCourse>> getAllUserCourse() async {
    try {
       _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));
       final response = await _dio.get(ApiConstants.userCourse);
       print('fetch all course user');
      if (response.statusCode == 200) {
        final List<dynamic> courseJson = response.data;
        print(response.data);
        return courseJson.map((json) => UserCourse.fromJson(json)).toList();
      }
      return const <UserCourse>[];
    } on DioException catch (e) {
      print('Error getting user courses: ${e.message}');
      return const <UserCourse>[];
    }
  }

  Future<List<Course>> getAllCourse() async {
    try {
      final response = await _dio.get(ApiConstants.courses);
      print('fetch all course user');
      if (response.statusCode == 200) {
        final List<dynamic> courseJson = response.data;

        return courseJson.map((json) => Course.fromJson(json)).toList();
      }
      return const <Course>[];
    } on DioException catch (e) {
      print('Error getting all courses: ${e.message}');
      return const <Course>[];
    }
  }

  Future<List<Course>> getCourseByCategoryId(
      int categoryId, {
        int page = 1,
        int pageSize = 10,
      }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.courseByCategory}/$categoryId',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );
      print('get all course favorite');
      if (response.statusCode == 200) {
        final List<dynamic> courseJson = response.data;
        return courseJson.map((json) => Course.fromJson(json)).toList();
      }
      return const <Course>[];
    } on DioException catch (e) {
      print('Error getting courses by category: ${e.message}');
      return const <Course>[];
    }
  }

  Future<List<Course>> getAllCourseNew({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.courseNew,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );
      print('get all course new');
      if (response.statusCode == 200) {
        final List<dynamic> courseJson = response.data;
        return courseJson.map((json) => Course.fromJson(json)).toList();
      }
      return const <Course>[];
    } on DioException catch (e) {
      print('Error getting new courses: ${e.message}');
      return const <Course>[];
    }
  }

  Future<List<Course>> getAllCourseFavorites({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.courseFavorite,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> courseJson = response.data;
        return courseJson.map((json) => Course.fromJson(json)).toList();
      }
      return const <Course>[];
    } on DioException catch (e) {
      print('Error getting favorite courses: ${e.message}');
      return const <Course>[];
    }
  }

  Future<List<Course>> getFilterCourse(
      String keyword, {
        int page = 1,
        int pageSize = 10,
        int categoryId = 0,
        int instructorId = 0,
      }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'keyword': keyword,
        'page': page,
        'pageSize': pageSize,
      };

      // Chỉ thêm các tham số không phải giá trị mặc định
      if (categoryId != 0) queryParams['categoryId'] = categoryId;
      if (instructorId != 0) queryParams['instructorId'] = instructorId;

      final response = await _dio.get(
        ApiConstants.courseFilter,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> courseJson = response.data;
        return courseJson.map((json) => Course.fromJson(json)).toList();
      }
      return const <Course>[];
    } on DioException catch (e) {
      print('Error filtering courses: ${e.message}');
      print('Error details: ${e.response?.data}');
      return const <Course>[];
    }
  }
  Future<Course> getCourseById(int courseId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.courses}/$courseId',
      );

      if (response.statusCode == 200) {
        return Course.fromJson(response.data);
      } else {
        throw Exception('Failed to load course');
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

}
