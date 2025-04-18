import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/data/model/user.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';

class UserService{
  final Dio _dio;
  final AuthRepository _authRepository;
  UserService(AuthRepository authRepository, {Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  )),_authRepository = authRepository{
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<User?> getUserInfo() async{
    _dio.interceptors.add(
      TokenInterceptor(authRepository: _authRepository, dio: _dio)
    );
    final response = await _dio.get(ApiConstants.user);
    if(response.data !=null){
      return User.fromJson(response.data);
    }
    return null;
  }
}