
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/shared/models/category.dart';

class CategoryApiClient {
  final Dio _dio;
  CategoryApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    // Cấu hình bỏ qua chứng chỉ SSL tại đây
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<List<Category>> getAllCategories() async {
    final request = Uri.https(ApiConstants.baseUrl, ApiConstants.category).toString();
    try {
      final response = await _dio.get(request);

      if (response.statusCode != 200) {
        return const [];
      }
      print('Request successful: $request');

      final List<dynamic> categoriesJson = response.data;
      final categories = categoriesJson.map((json) {
        return Category.fromJson(json);
      }).toList();

      return categories;
    } catch (e) {
      print('Error occurred: $e');
      return const [];
    }
  }

}
