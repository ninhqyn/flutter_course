import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/data/model/quiz.dart';
import 'package:learning_app/src/data/model/quiz_result_request.dart';
import 'package:learning_app/src/data/model/quiz_result_response.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';


class QuizService {
  final Dio _dio;
  final AuthRepository _authRepository;
  QuizService(AuthRepository authRepository,{Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
  )),_authRepository = authRepository{
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

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
      debugPrint('Error getting quiz: ${e.message}');
      debugPrint('Error details: ${e.response?.data}');
      return null;
    }
  }
  Future<QuizResultResponse> submitQuiz(QuizResultRequest request) async {
    _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));
    try {
      final response = await _dio.post(
          ApiConstants.quizResult,
          data: request.toJson()
      );
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        final quizResult = response.data;
        return QuizResultResponse.fromJson(quizResult);
      } else {
        throw Exception('Failed to submit quiz: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('Error submitting quiz: ${e.message}');
      debugPrint('Error details: ${e.response?.data}');
      throw Exception('Failed to submit quiz: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('An unexpected error occurred');
    }
  }
  Future<List<QuizResultResponse>> getAllQuizResultsByQuizId(int quizId) async {
    // Thêm token interceptor để xử lý xác thực
    _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));

    try {
      final response = await _dio.get('${ApiConstants.getAllQuizResult}/$quizId');

      debugPrint('Request URL: ${_dio.options.baseUrl}${ApiConstants.getAllQuizResult}/$quizId');

      if (response.statusCode == 200) {
        if (response.data is Map && response.data['success'] == true && response.data['data'] is List) {
          final List<dynamic> resultsJson = response.data['data'];
          return resultsJson.map((json) => QuizResultResponse.fromJson(json)).toList();
        }
        else if (response.data is List) {
          final List<dynamic> resultsJson = response.data;
          return resultsJson.map((json) => QuizResultResponse.fromJson(json)).toList();
        }
      }

      debugPrint('Unexpected response format: ${response.data}');
      return const <QuizResultResponse>[];
    } on DioException catch (e) {
      debugPrint('Error getting quiz results: ${e.message}');
      debugPrint('Error details: ${e.response?.data}');
      return const <QuizResultResponse>[];
    } catch (e) {
      debugPrint('Unexpected error when fetching quiz results: $e');
      return const <QuizResultResponse>[];
    }
  }
}
