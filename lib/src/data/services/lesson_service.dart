import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/data/model/post_lesson_progress.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';

class LessonService {
  final Dio _dio;
  final AuthRepository _authRepository;
  LessonService(AuthRepository authRepository,{Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  )),_authRepository = authRepository{
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<bool> createOrUpdateLessonProgress(PostLessonProgress model) async {
    try {
      _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));
      final response = await _dio.post(ApiConstants.lessonProgress,data: model.toJson());

      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.lessonProgress}');

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      print('Error getting quiz: ${e.message}');
      print('Error details: ${e.response?.data}');
      return false;
    }
  }

}
