import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/data/model/cart_item_model.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import '../model/cart_response.dart';

class CartService {
  final Dio _dio;
  final AuthRepository _authRepository;

  CartService(this._authRepository, {Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
  )) {
    _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  // Get all items in user's cart
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final response = await _dio.get(ApiConstants.getCartItem);
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => CartItemModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      throw Exception('Failed to load cart items: ${e.toString()}');
    }
  }

  Future<ApiResponse> addToCart(int courseId) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.addToCart}/$courseId',
      );

      final data = response.data;
      final message = data['message']?.toString() ?? '';

      String? status;

      if (message.contains('thêm vào giỏ hàng')) {
        status = 'added';
      } else if (message.contains('kích hoạt lại')) {
        status = 'reactivated';
      } else if (message.contains('đã có trong giỏ hàng')) {
        status = 'already_in_cart';
      }

      return ApiResponse(
        success: true,
        message: message,
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        return ApiResponse(
          success: false,
          message: 'Không thể thêm khóa học vào giỏ hàng',
          error: e.response?.data['message'] ?? e.message,
        );
      }
      return ApiResponse(
        success: false,
        message: 'Không thể thêm khóa học vào giỏ hàng',
        error: e.toString(),
      );
    }
  }


  // Remove a course from cart
  Future<ApiResponse> removeFromCart(int courseId) async {
    try {
      final response = await _dio.delete(
        '${ApiConstants.removeCart}/$courseId',
      );

      return ApiResponse.fromJson(response.data, null);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return ApiResponse(
            success: false,
            message: 'Failed to remove course from cart',
            error: e.response?.data['message'] ?? e.message,
          );
        }
      }
      return ApiResponse(
        success: false,
        message: 'Failed to remove course from cart',
        error: e.toString(),
      );
    }
  }

  // Clear all items from cart
  Future<ApiResponse> clearCart() async {
    try {
      final response = await _dio.delete(
        ApiConstants.clearCart,
      );

      return ApiResponse.fromJson(response.data, null);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return ApiResponse(
            success: false,
            message: 'Failed to clear cart',
            error: e.response?.data['message'] ?? e.message,
          );
        }
      }
      return ApiResponse(
        success: false,
        message: 'Failed to clear cart',
        error: e.toString(),
      );
    }
  }

  // Check if course is in cart
  Future<bool> isCourseInCart(int courseId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.checkCart}/$courseId',
      );

      if (response.statusCode == 200) {
        return response.data['isInCart'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}