import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/src/data/model/payment_model.dart';

class PaymentHistoryItem extends StatelessWidget{
  const PaymentHistoryItem({super.key, required this.paymentModel});
  final PaymentModel paymentModel;
  @override
  Widget build(BuildContext context) {
    final payment = paymentModel;
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(payment.createdAt!);
    final formattedAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(payment.amount);
    final isNegativeAmount = payment.amount < 0;
    final amountColor = isNegativeAmount ? Colors.red[600] : Colors.green[600];

    // Lấy thông tin mô tả từ paymentDetails (có thể tùy chỉnh logic này)
    String description = 'Đơn hàng #${payment.paymentId}';
    if (payment.paymentDetails != null && payment.paymentDetails!.isNotEmpty) {
      if (payment.paymentDetails!.length == 1) {
        description = payment.paymentDetails!.first.itemType;
      } else {
        description = '${payment.paymentDetails!.length} mục hàng';
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              isNegativeAmount ? Icons.arrow_downward : Icons.arrow_upward,
              color: amountColor,
              size: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (payment.paymentMethod != null)
                    Text(
                      'Phương thức: ${payment.paymentMethod}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedAmount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment.paymentStatus ?? 'Đang xử lý',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}