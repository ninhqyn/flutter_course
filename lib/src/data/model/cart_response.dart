class ApiResponse<T> {
  final String? message;
  final T? data;
  final bool success;
  final String? error;

  ApiResponse({
    this.message,
    this.data,
    required this.success,
    this.error,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse(
      message: json['message'],
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
      success: json['success'] ?? true,
      error: json['error'],
    );
  }
}