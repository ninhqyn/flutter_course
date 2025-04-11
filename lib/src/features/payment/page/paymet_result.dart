import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/src/data/model/result_model.dart';
import 'package:learning_app/src/shared/utils/date_time_util.dart';

class PaymentResult extends StatelessWidget {
  final ModelResult result;
  const PaymentResult({super.key, required this.result,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildResultHeader(),
              const SizedBox(height: 40),
              _buildTransactionDetails(context),
              const SizedBox(height: 40),
               _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultHeader() {
    return Column(
      children: [
        result.isSuccess
            ? Image.asset(
          'assets/images/payment_success.png',
          height: 120,
        )
            : result.responseCode =='24'? const Icon(
          Icons.cancel,
          size: 120,
          color: Colors.red,
        ):const Icon(
          Icons.error_outline,
          size: 120,
          color: Colors.red,
        ),
        const SizedBox(height: 24),
        result.isSuccess ?
        Text(
          'Đăng ký thành công!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: result.isSuccess ? Colors.lightBlue : Colors.red,
          ),
        ):Text(
          result.responseCode =='24' ? 'Giao dịch đã bị hủy!':'Có lỗi xảy ra!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: result.isSuccess ? Colors.lightBlue : Colors.red,
          ),
        ),
        const SizedBox(height: 12),
        if(result.isSuccess)
        Text(
          NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(result.amount),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildDetailRow('Mã giao dịch', result.transactionId),
          const Divider(height: 24),
          _buildDetailRow('Nội dung', result.content),
          const Divider(height: 24),
          _buildDetailRow(
            'Thời gian',
            DateTimeUtil.formatFromRawString (result.payDate),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        if(result.isSuccess)
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Implement share receipt functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Đi tới khóa học',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: () {
              // Navigate back to home screen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              backgroundColor: result.isSuccess ? Colors.white :Colors.lightBlue
            ),
            child: const Text(
              'Về trang chủ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}