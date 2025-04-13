class ApiResponse{
  final bool isSuccess;
  final String message;
  final String statusCode;

  ApiResponse({
    required this.isSuccess,
    required this.message,
    required this.statusCode
});
}