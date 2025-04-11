import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/shared/models/skill.dart';

class SkillService {
  final Dio _dio;

  SkillService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  )){
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<List<Skill>> getAllSkillByCourseId(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.skill}/$courseId');

      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.skill}/$courseId');

      if (response.statusCode == 200) {
        final List<dynamic> skillJson = response.data;
        return skillJson.map((json) => Skill.fromJson(json)).toList();
      }

      return const <Skill>[];
    } on DioException catch (e) {
      print('Error getting skills: ${e.message}');
      print('Error details: ${e.response?.data}');
      return const <Skill>[];
    }
  }
}
