import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/data/model/api_response.dart';

import 'package:learning_app/src/data/model/token_model.dart';

import '../model/auth_response.dart';



enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  userNotFound,
  invalidPassword,
  emailRequired,
  tokenValid,
  tokenInvalid,
  tokenExpired
}

class AuthService {
  final Dio _dio;

  AuthService() : _dio = Dio() {
    // Cấu hình bỏ qua xác thực SSL ngay khi khởi tạo
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {


      final response = await _dio.post(
        Uri.https(ApiConstants.baseUrl, ApiConstants.authLogin).toString(),
        data: {
          'email': email,
          'password': password,
        },
      );
      switch (response.statusCode) {
        case 200:
        // Successful login
          return AuthResponse(
            status: AuthStatus.authenticated,
            message: 'Login successful',
            tokenModel: TokenModel.fromJson(response.data),
          );
        case 404:
        // User not found
          return AuthResponse(
            status: AuthStatus.userNotFound,
            message: 'User not found',
          );
        case 400:
        // Email required or invalid
          return AuthResponse(
            status: AuthStatus.emailRequired,
            message: response.data['message'] ?? 'Invalid email',
          );
        case 401:
        // Invalid password
          return AuthResponse(
            status: AuthStatus.invalidPassword,
            message: 'Invalid password',
          );
        default:
        // Unexpected response
          return AuthResponse(
            status: AuthStatus.unauthenticated,
            message: 'Unexpected error occurred',
          );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 404:
            return AuthResponse(
              status: AuthStatus.userNotFound,
              message: 'User not found',
            );
          case 401:
            return AuthResponse(
              status: AuthStatus.invalidPassword,
              message: 'Invalid password',
            );
          default:
            return AuthResponse(
              status: AuthStatus.unauthenticated,
              message: e.response?.data['message'] ?? 'Login failed',
            );
        }
      }

      // Network or other errors
      return AuthResponse(
        status: AuthStatus.unknown,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      // Catch any other unexpected errors
      return AuthResponse(
        status: AuthStatus.unknown,
        message: 'Unexpected error: $e',
      );
    }
  }
  //
  Future<bool> verifyToken(String accessToken) async {
    try {
      final response = await _dio.post(
        Uri.https(ApiConstants.baseUrl, ApiConstants.authVerifyToken).toString(),
        data: {
          'accessToken': accessToken,
        },
        options: Options(
          validateStatus: (status) {
            return status == 200 || status == 401;
          },
        ),
      );

      return response.statusCode == 200;

    } on DioException catch (e) {
      if (e.response != null) {

        if (e.response!.statusCode == 401) {
          return false;
        }
      }

      return false;

    } catch (e) {

      return false;
    }
  }
  Future<TokenModel?> refreshToken(TokenModel token) async {
    try {
      final response = await _dio.post(
        Uri.https(ApiConstants.baseUrl, ApiConstants.authRefreshToken).toString(),
        data: {
          'accessToken': token.accessToken,
          'refreshToken': token.refreshToken,
        },
        options: Options(
          validateStatus: (status) {
            return status == 200 || status == 401 || status == 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return TokenModel.fromJson(response.data);
      }

      // Handle specific error cases based on response
      if (response.statusCode == 401) {

      }

      return null;

    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('Refresh token error: ${e.response?.data['message']}');
      } else {
        debugPrint('Network/timeout error during token refresh');
      }
      return null;

    } catch (e) {
      debugPrint('Unexpected error during token refresh: $e');
      return null;
    }
  }
  Future<ApiResponse> signUpWithEmail(String userName, String email, String password, String confirmPassword) async {
    try {
      final response = await _dio.post(
        Uri.https(ApiConstants.baseUrl, ApiConstants.register).toString(),
        data: {
          "userName": userName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword
        },
      );

      debugPrint("Sign up status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return ApiResponse(
            isSuccess: true,
            message: "Mã xác thực đã được gửi đến email của bạn",
            statusCode: response.statusCode.toString()
        );
      }

      // Trường hợp response không phải 200 nhưng không ném ngoại lệ
      return ApiResponse(
          isSuccess: false,
          message: response.data?["message"] ?? "Username hoặc email đã tồn tại!",
          statusCode: response.statusCode.toString()
      );
    } catch (e) {
      debugPrint("Sign up error: $e");

      // Xử lý lỗi từ DioException
      if (e is DioException) {
        // Truy cập response data nếu có
        if (e.response != null) {
          final statusCode = e.response?.statusCode;
          final responseData = e.response?.data;

          debugPrint("Error status code: $statusCode");
          debugPrint("Error response data: $responseData");

          // Xử lý mã lỗi 400
          if (statusCode == 400) {
            final message = responseData?["message"] ?? "Username hoặc email đã tồn tại!";
            return ApiResponse(
                isSuccess: false,
                message: message,
                statusCode: statusCode.toString()
            );
          }
        }

        // Lỗi kết nối hoặc lỗi khác liên quan đến Dio
        String errorMessage = "Lỗi kết nối đến máy chủ";
        if (e.type == DioExceptionType.connectionTimeout) {
          errorMessage = "Kết nối đến máy chủ bị quá thời gian";
        } else if (e.type == DioExceptionType.receiveTimeout) {
          errorMessage = "Nhận dữ liệu từ máy chủ bị quá thời gian";
        }

        return ApiResponse(
            isSuccess: false,
            message: errorMessage,
            statusCode: e.response?.statusCode?.toString() ?? "unknown"
        );
      }

      // Lỗi khác không phải DioException
      return ApiResponse(
          isSuccess: false,
          message: "Đã có lỗi xảy ra, vui lòng thử lại sau",
          statusCode: "unknown"
      );
    }
  }

  Future<ApiResponse> verifyCode(String email, String code) async {
    try {
      final response = await _dio.post(
        Uri.https(ApiConstants.baseUrl, ApiConstants.verifyCode).toString(),
        data: {
          "email": email,
          "code": code,
        },
      );

      debugPrint("Verify code status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return ApiResponse(
            isSuccess: true,
            message: "Xác thực thành công!",
            statusCode: response.statusCode.toString()
        );
      }

      // Trường hợp response không phải 200 nhưng không ném ngoại lệ
      return ApiResponse(
          isSuccess: false,
          message: response.data?["message"] ?? "Mã xác thực không chính xác!",
          statusCode: response.statusCode.toString()
      );
    } catch (e) {
      debugPrint("Verify code error: $e");
      if (e is DioException) {
        // Truy cập response data nếu có
        if (e.response != null) {
          final statusCode = e.response?.statusCode;
          final responseData = e.response?.data;

          debugPrint("Error status code: $statusCode");
          debugPrint("Error response data: $responseData");

          // Xử lý mã lỗi 400
          if (statusCode == 400) {
            final message = responseData?["message"] ?? "Mã xác thực không chính xác!";
            return ApiResponse(
                isSuccess: false,
                message: message,
                statusCode: statusCode.toString()
            );
          }
        }

        // Lỗi kết nối hoặc lỗi khác liên quan đến Dio
        String errorMessage = "Lỗi kết nối đến máy chủ";
        if (e.type == DioExceptionType.connectionTimeout) {
          errorMessage = "Kết nối đến máy chủ bị quá thời gian";
        } else if (e.type == DioExceptionType.receiveTimeout) {
          errorMessage = "Nhận dữ liệu từ máy chủ bị quá thời gian";
        }

        return ApiResponse(
            isSuccess: false,
            message: errorMessage,
            statusCode: e.response?.statusCode?.toString() ?? "unknown"
        );
      }

      // Lỗi khác không phải DioException
      return ApiResponse(
          isSuccess: false,
          message: "Đã có lỗi xảy ra, vui lòng thử lại sau",
          statusCode: "unknown"
      );
    }
  }
}