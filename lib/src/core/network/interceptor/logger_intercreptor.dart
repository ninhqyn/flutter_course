import 'package:dio/dio.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    // Ghi lại thông tin yêu cầu
    print('Request: ${options.method} ${options.uri}');
    //print('Request Headers: ${options.headers}');
    //print('Request Body: ${options.data}');
    // Có thể ghi log thêm thông tin vào file hoặc gửi tới hệ thống khác nếu cần.
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    // Ghi lại thông tin phản hồi
    print('Response: ${response.statusCode} ${response.requestOptions.uri}');
    //print('Response Body: ${response.data}');
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    // Ghi lại lỗi (nếu có)
    print('Error: ${err.message}');
    //print('Error: ${err.response?.statusCode} ${err.response?.data}');
  }
}
