import 'package:dio/dio.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
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
  final Dio _dio = Dio();

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
      print(token.refreshToken);
      if (response.statusCode == 200) {
        return TokenModel.fromJson(response.data);
      }

      // Handle specific error cases based on response
      if (response.statusCode == 401) {
        print(response.data['message']);
      }

      return null;

    } on DioException catch (e) {
      if (e.response != null) {
        print('Refresh token error: ${e.response?.data['message']}');
      } else {
        print('Network/timeout error during token refresh');
      }
      return null;

    } catch (e) {
      print('Unexpected error during token refresh: $e');
      return null;
    }
  }

}