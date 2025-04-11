import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/shared/models/rating.dart';
import 'package:learning_app/src/shared/models/rating_total.dart';

class RatingService {
  final Dio _dio;

  RatingService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  )){(_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };}

  Future<RatingTotal> getRatingTotalByCourseId(int courseId) async {
    try {
      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.ratingTotal}/$courseId');

      final response = await _dio.get(
        '${ApiConstants.ratingTotal}/$courseId',
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        return RatingTotal.fromJson(response.data);
      }

      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiConstants.ratingTotal}/$courseId',
        ),
        error: 'Failed to load rating data',
      );

    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      if (e.response != null) {
        print('Error status: ${e.response?.statusCode}');
        print('Error data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
  Future<List<Rating>> getAllRatingByCourseId(
      int courseId,{
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.ratingCourse}/$courseId');

      final response = await _dio.get(
        '${ApiConstants.ratingCourse}/$courseId',
        options: Options(
          responseType: ResponseType.json,
        ),
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> ratingJsonList = response.data;
        return ratingJsonList.map((ratingJson) {
          // Đảm bảo ratingJson và ratingJson['user'] là Map<String, dynamic>
          return Rating.fromJson(ratingJson);
        }).toList();
      }
      if(response.statusCode == 404){
        return const<Rating>[];
      }

      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiConstants.ratingCourse}/$courseId',
        ),
        error: 'Failed to load rating data',
      );

    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      if (e.response != null) {
        print('Error status: ${e.response?.statusCode}');
        print('Error data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
}
