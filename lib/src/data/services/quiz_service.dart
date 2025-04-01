import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/data/model/quiz.dart';


class QuizService {
  final Dio _dio;

  QuizService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<Quiz>> getAllQuizByCourseId(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.quizByCourse}/$courseId');

      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.quiz}/$courseId');

      if (response.statusCode == 200) {
        final List<dynamic> quizJson = response.data;
        return quizJson.map((json) => Quiz.fromJson(json)).toList();
      }

      return const <Quiz>[];
    } on DioException catch (e) {
      print('Error getting quiz: ${e.message}');
      print('Error details: ${e.response?.data}');
      return const <Quiz>[];
    }
  }
  Future<Quiz?> getQuizById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.quiz}/$id');

      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.quiz}/$id');

      if (response.statusCode == 200) {
        final  quizJson = jsonDecode( response.data);
        return Quiz.fromJson(quizJson);
      }

      return null;
    } on DioException catch (e) {
      print('Error getting quiz: ${e.message}');
      print('Error details: ${e.response?.data}');
      return null;
    }
  }
}
