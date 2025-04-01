import 'package:dio/dio.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/data/data_scources/auth_local_data_source.dart';
import 'package:learning_app/src/data/model/token_model.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';

class TokenInterceptor extends Interceptor {
  final AuthRepository authRepository;
  final Dio dio;
  bool _isRefreshing = false;

  TokenInterceptor({
    required this.authRepository,
    required this.dio,
  });

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await authRepository.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.response?.statusCode == 401 && err.response?.data['message'] =='Invalid token') {
      try {
        if (!_isRefreshing) {
          _isRefreshing = true;

          // Sử dụng AuthRepository để refresh token
          final newToken = await authRepository.refreshToken();
          if (newToken != null) {
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer ${newToken.accessToken}';

            final response = await dio.fetch(opts);
            _isRefreshing = false;
            return handler.resolve(response);
          } else {
            // Nếu refresh thất bại
            _isRefreshing = false;
            await authRepository.clearTokens(); // Sử dụng phương thức từ repository
            return handler.next(err);
          }
        }
      } catch (e) {
        _isRefreshing = false;
        await authRepository.clearTokens(); // Sử dụng phương thức từ repository
        return handler.next(err);
      }
    }
    return handler.next(err);
  }
}
