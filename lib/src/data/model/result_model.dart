class ModelResult {
  final String transactionId; // vnp_TxnRef - Mã đơn hàng
  final double amount; // vnp_Amount (đã chuyển đổi)
  final String content; // vnp_OrderInfo - Nội dung giao dịch
  final bool isSuccess; // Dựa trên vnp_ResponseCode
  final String payDate; // vnp_PayDate - Ngày thanh toán
  final String responseCode;
  final int courseId;
  ModelResult({
    required this.transactionId,
    required this.amount,
    required this.content,
    required this.isSuccess,
    required this.payDate,
    required this.responseCode,
    required this.courseId
  });


}