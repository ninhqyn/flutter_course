import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';

class PaymentService {
  final Dio _dio;
  final AuthRepository _authRepository;

  PaymentService(AuthRepository authRepository, {Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',

  )),
        _authRepository = authRepository {
    // Cấu hình bỏ qua xác thực SSL
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<List<PaymentModel>> getAllPaymentHistory() async {
    try {
      _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));
      final response = await _dio.get(ApiConstants.getAllPayment); // Corrected endpoint
      if (response.statusCode == 200) {
        final List<dynamic> paymentHistoryJson = response.data as List<dynamic>;
        return paymentHistoryJson.map((json) => PaymentModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        print('Failed to get payment history. Status code: ${response.statusCode}');
        return const <PaymentModel>[];
      }
    } on DioException catch (e) {
      print('Error getting payment history: ${e.message}');
      return const <PaymentModel>[];
    }
  }

  Future<PaymentModel?> getPaymentById(int paymentId) async {
    try {
      _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));
      final response = await _dio.get('${ApiConstants.payment}/$paymentId'); // Corrected endpoint with ID
      if (response.statusCode == 200 && response.data != null) {
        return PaymentModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        print('Failed to get payment by ID. Status code: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('Error getting payment by ID: ${e.message}');
      return null;
    }
  }

  Future<bool> deletePaymentHistory(int paymentId) async {
    try {
      _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));
      final response = await _dio.delete('${ApiConstants.payment}/$paymentId'); // Corrected endpoint with ID
      if (response.statusCode == 204) {
        return true; // Deletion successful (204 No Content is typical for successful deletion)
      } else {
        print('Failed to delete payment history. Status code: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('Error deleting payment history: ${e.message}');
      return false;
    }
  }
}