import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
class VnPayService {
  final Dio _dio;
  final AuthRepository _authRepository;
  final AppLinks _appLinks = AppLinks();
  Function(Map<String, String>)? _onPaymentSuccess;
  Function(Map<String, String>)? _onPaymentFailure;

  VnPayService(AuthRepository authRepository, {Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
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

  Future<String?> createVnPayPayment({
    required double amount,
    required String orderDescription,
    String bankCode = '',
    String language = 'vn',
    String orderType = 'billpayment',
    required List<int> courses,
    Function(String)? onOrderCreated,
  }) async {
    try {
      _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));
      // Tạo unique orderId
      final orderId = 'ORDER${DateTime.now().millisecondsSinceEpoch}';
      final response = await _dio.post(
        '/api/VnPay/create-payment',
        data: {
          'orderId': orderId,
          'amount': amount.toInt(),
          'orderDescription': orderDescription,
          'bankCode': bankCode,
          'language': language,
          'orderType': orderType,
          'courses': courses,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        if (onOrderCreated != null) {
          onOrderCreated(orderId);
        }
        final paymentUrl = response.data['payment_url'];
        return paymentUrl.trim();
      } else {
        debugPrint('Lỗi API: ${response.statusCode} - ${response.data}');
        return null;
      }
    } catch (e) {
      debugPrint('Error creating payment: $e');
      return null;
    }
  }

  Future<String?> createVnPayPaymentSingleCourse({
    required double amount,
    required String orderDescription,
    String bankCode = '',
    String language = 'vn',
    String orderType = 'billpayment',
    required int courseId,
    Function(String)? onOrderCreated,
  }) async {
    return createVnPayPayment(
      amount: amount,
      orderDescription: orderDescription,
      bankCode: bankCode,
      language: language,
      orderType: orderType,
      courses: [courseId],
      onOrderCreated: onOrderCreated,
    );
  }

  void _handleAppLink(Uri uri) {
    print("Received URI: $uri"); // Debugging

    if (uri.host == 'payment-result') {
      final params = uri.queryParameters;

      // Kiểm tra cả hai kiểu tham số (từ server hoặc từ VNPay)
      final responseCode = params['vnp_ResponseCode'] ?? params['response_code'] ?? '';
      final txnRef = params['vnp_TxnRef'] ?? params['order_id'] ?? '';

      switch(responseCode) {
        case '00': // Thành công
          if (_onPaymentSuccess != null) {
            _onPaymentSuccess!(Map<String, String>.from(params));
          }
          break;

        default:
          if (_onPaymentFailure != null) {
            _onPaymentFailure!(Map<String, String>.from(params));
          }
          break;
      }
    }
  }

  // Đăng ký callbacks cho kết quả thanh toán
  void registerPaymentCallbacks({
    required Function(Map<String, String>) onSuccess,
    required Function(Map<String, String>) onFailure,
  }) {
    _onPaymentSuccess = onSuccess;
    _onPaymentFailure = onFailure;

    // Đăng ký lắng nghe app links
    _appLinks.uriLinkStream.listen(_handleAppLink);
  }

  // Xác thực kết quả thanh toán với server (nên thực hiện để đảm bảo an toàn)
  // Future<bool> _verifyPaymentResult(Map<String, dynamic> params) async {
  //   try {
  //     final response = await _dio.post(
  //       '/api/VnPay/verify-payment',
  //       data: params,
  //     );
  //
  //     return response.statusCode == 210 && response.data['success'] == true;
  //   } catch (e) {
  //     debugPrint('Error verifying payment: $e');
  //     return false;
  //   }
  // }
}