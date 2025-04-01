import 'package:dio/dio.dart';
import 'package:learning_app/src/core/constants/api_constants.dart';
import 'package:learning_app/src/core/network/interceptor/token_interceptor.dart';
import 'package:learning_app/src/data/model/user_module.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/shared/models/module.dart';

class ModuleService {
  final Dio _dio;
  final AuthRepository _authRepository;
  ModuleService(AuthRepository authRepository,{Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://${ApiConstants.baseUrl}',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  )),_authRepository = authRepository;

  Future<List<Module>> getAllModuleByCourseId(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.module}/$courseId');

      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.module}/$courseId');

      if (response.statusCode == 200) {
        final List<dynamic> moduleJson = response.data;
        return moduleJson.map((json) => Module.fromJson(json)).toList();
      }

      return const <Module>[];
    } on DioException catch (e) {
      print('Error getting modules: ${e.message}');
      print('Error details: ${e.response?.data}');
      return const <Module>[];
    }
  }
  Future<List<UserModule>> getAllUserModuleByCourseId(int courseId) async {
    try {
      _dio.interceptors.add(TokenInterceptor(authRepository: _authRepository, dio: _dio));
      final response = await _dio.get('${ApiConstants.moduleUser}/$courseId');

      print('Request URL: ${_dio.options.baseUrl}${ApiConstants.moduleUser}/$courseId');
      if (response.statusCode == 200) {
        final List<dynamic> moduleJson = response.data;
        return moduleJson.map((json) => UserModule.fromJson(json)).toList();
      }

      return const <UserModule>[];
    } on DioException catch (e) {
      print('Error getting modules: ${e.message}');
      print('Error details: ${e.response?.data}');
      return const <UserModule>[];
    }
  }
}
