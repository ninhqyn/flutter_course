import 'package:dio/dio.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';

import 'interceptor/logger_intercreptor.dart';
import 'interceptor/token_interceptor.dart';


class DioClient {
  late Dio dio;
  DioClient(AuthRepository authRepository) {
    dio = Dio();
    dio.interceptors.add(TokenInterceptor(authRepository: authRepository, dio: dio));
    dio.interceptors.add(LoggerInterceptor());
  }

  Dio get client => dio;
}
