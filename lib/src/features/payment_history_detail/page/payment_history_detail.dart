import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/model/payment_model.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/data/repositories/payment_repository.dart';
import 'package:learning_app/src/features/payment_history_detail/bloc/payment_history_detail_bloc.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:learning_app/src/shared/utils/date_time_util.dart';
import 'package:learning_app/src/shared/utils/price_format.dart';

class PaymentHistoryDetail extends StatelessWidget {
  final int paymentId;
  const PaymentHistoryDetail({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentHistoryDetailBloc(
        paymentId: paymentId,
        courseRepository: context.read<CourseRepository>(),
        paymentRepository: context.read<PaymentRepository>(),
      )..add(FetchDataDetailHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi Tiết Thanh Toán',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        body: const PaymentHistoryDetailView(),
      ),
    );
  }
}

class PaymentHistoryDetailView extends StatefulWidget {
  const PaymentHistoryDetailView({super.key});

  @override
  State<PaymentHistoryDetailView> createState() => _PaymentHistoryDetailViewState();
}

class _PaymentHistoryDetailViewState extends State<PaymentHistoryDetailView> {
  late PaymentHistoryDetailBloc _paymentDetailBloc;

  @override
  void initState() {
    super.initState();
    _paymentDetailBloc = context.read<PaymentHistoryDetailBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryDetailBloc, PaymentHistoryDetailState>(
      builder: (context, state) {
        if (state is PaymentHistoryDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PaymentHistoryDetailLoaded) {
          final paymentModel = state.payments;
          final courses = state.courses;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentSummary(paymentModel),
                const SizedBox(height: 16),
                _buildPaymentDetails(paymentModel, courses),
              ],
            ),
          );
        } else if (state is PaymentHistoryDetailError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text('Đã xảy ra lỗi: ${state.message}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _paymentDetailBloc.add(FetchDataDetailHistory()),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text('Đang tải thông tin chi tiết...'),
        );
      },
    );
  }

  Widget _buildPaymentSummary(PaymentModel paymentModel) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mã Giao Dịch',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${paymentModel.paymentId}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(paymentModel.paymentStatus).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  paymentModel.paymentStatus ?? 'Chưa xác định',
                  style: TextStyle(
                    color: _getStatusColor(paymentModel.paymentStatus),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white30, height: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ngày Thanh Toán',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    paymentModel.createdAt != null
                        ? DateTimeUtil.formatDateTime(paymentModel.createdAt!)
                        : 'Chưa có dữ liệu',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Tổng Thanh Toán',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    paymentModel.amount.toCurrencyVND(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (paymentModel.paymentMethod != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                _buildPaymentMethodIcon(paymentModel.paymentMethod!),
                const SizedBox(width: 8),
                Text(
                  paymentModel.paymentMethod!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(dynamic paymentModel, List<Course> courses) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi Tiết Đơn Hàng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (paymentModel.discountId != null) ...[
            _buildInfoRow(
              'Mã giảm giá',
              paymentModel.discountId.toString(),
              icon: Icons.discount_outlined,
            ),
            const SizedBox(height: 8),
          ],
          if (paymentModel.discountAmount != null) ...[
            _buildInfoRow(
              'Số tiền giảm',
              paymentModel.discountAmount.toString(),
              icon: Icons.money_off_outlined,
              valueColor: Colors.green[700],
            ),
            const SizedBox(height: 8),
          ],
          if (paymentModel.transactionId != null) ...[
            _buildInfoRow(
              'Transaction ID',
              paymentModel.transactionId!,
              icon: Icons.receipt_long_outlined,
            ),
            const SizedBox(height: 16),
          ],
          const Divider(),
          const SizedBox(height: 16),
          if (paymentModel.paymentDetails != null &&
              paymentModel.paymentDetails!.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentModel.paymentDetails!.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final detail = paymentModel.paymentDetails![index];
                final isCourse = detail.itemType.toLowerCase() == 'course';

                // Find course if this is a course item
                Course? course;
                if (isCourse) {
                  try {
                    course = courses.firstWhere(
                          (c) => c.courseId == detail.itemId,
                    );
                  } catch (e) {
                    // Course not found
                  }
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isCourse && course != null) ...[
                        _buildCourseItem(course, detail),
                      ] else ...[
                        Text(
                          detail.itemType.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow('Mã sản phẩm', detail.itemId.toString()),
                        const SizedBox(height: 8),
                        _buildInfoRow('Đơn giá', detail.unitPrice),
                        if (detail.quantity != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow('Số lượng', detail.quantity.toString()),
                        ],
                        const SizedBox(height: 8),
                        _buildInfoRow('Tổng cộng', detail.subtotal,
                            valueStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            )),
                      ],
                    ],
                  ),
                );
              },
            )
          else
            const Center(
              child: Text('Không có chi tiết đơn hàng.'),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(Course course, dynamic detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              course.thumbnailUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        Text(
          course.courseName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.category_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              course.category.categoryName,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${course.durationHours} giờ',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.signal_cellular_alt, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              course.difficultyLevel,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đơn giá',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                Text(
                  double.tryParse(detail.unitPrice.toString())!.toCurrencyVND(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),


          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {
    IconData? icon,
    Color? valueColor,
    TextStyle? valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
        ],
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ?? TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodIcon(String method) {
    IconData iconData;

    final lowerMethod = method.toLowerCase();
    if (lowerMethod.contains('momo')) {
      iconData = Icons.account_balance_wallet;
    } else if (lowerMethod.contains('banking') || lowerMethod.contains('bank')) {
      iconData = Icons.account_balance;
    } else if (lowerMethod.contains('card') || lowerMethod.contains('visa') || lowerMethod.contains('master')) {
      iconData = Icons.credit_card;
    } else if (lowerMethod.contains('cash') || lowerMethod.contains('tiền mặt')) {
      iconData = Icons.payments;
    } else {
      iconData = Icons.payment;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, size: 20, color: Theme.of(context).primaryColor),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('success') ||
        lowerStatus.contains('thành công') ||
        lowerStatus.contains('hoàn thành')) {
      return Colors.green;
    } else if (lowerStatus.contains('pending') ||
        lowerStatus.contains('chờ') ||
        lowerStatus.contains('processing')) {
      return Colors.orange;
    } else if (lowerStatus.contains('failed') ||
        lowerStatus.contains('thất bại') ||
        lowerStatus.contains('lỗi')) {
      return Colors.red;
    } else if (lowerStatus.contains('refund') ||
        lowerStatus.contains('hoàn tiền')) {
      return Colors.purple;
    }

    return Colors.white;
  }
}