import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/core/payment/vnpay/vnpay_service.dart';
import 'package:learning_app/src/data/model/result_model.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/features/payment/bloc/payment_bloc.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:learning_app/src/shared/utils/price_format.dart';
import 'vnpay_webview.dart';

class PaymentPage extends StatelessWidget {
  final List<Course> courses;

  const PaymentPage({super.key, required this.courses});

  void _processPayment(BuildContext context) {
    context.read<PaymentBloc>().add(CheckOutSubmit());
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(
          VnPayService(context.read<AuthRepository>()),
          courses
      )..add(LoadCheckOut()), // Load checkout data when page opens
      child: Builder(
          builder: (context) {
            return BlocListener<PaymentBloc, PaymentState>(
              listener: (context, state) {
                if (state is PaymentLoaded && state.paymentUrl!=null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VnPayWebView(
                        paymentUrl: state.paymentUrl!,
                      ),
                    ),
                  );
                }
              },
              child: BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  if(state is PaymentLoading){
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator(),),
                    );
                  }
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Checkout'),
                      elevation: 0,
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCoursesSection(),
                          const SizedBox(height: 24),
                          _buildPriceSummarySection(),
                          const SizedBox(height: 24),
                          _buildPaymentMethodSection(),
                          const SizedBox(height: 40),
                          _buildCheckoutButton(context),
                        ],
                      ),
                    ),

                  );
                },
              ),
            );
          }
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: courses.length,
          separatorBuilder: (_, __) => const Divider(height: 24),
          itemBuilder: (context, index) => _CourseCard(course: courses[index]),
        ),
      ],
    );
  }

  Widget _buildPriceSummarySection() {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        if (state is PaymentLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Price Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _PriceSummaryCard(
                originalPrice: state.originalPrice,
                discountAmount: state.discountAmount,
                finalPrice: state.discountedPrice,
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _VNPayMethodCard(),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        if (state is PaymentLoaded) {
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _processPayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Pay ${state.discountedPrice.toCurrencyVND()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// Extracted Widgets
class _CourseCard extends StatelessWidget {
  final Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final discountedPrice = course.price * (1 - course.discountPercentage / 100);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CourseThumbnail(url: course.thumbnailUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.courseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.category.categoryName,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                _CourseMetadata(
                  duration: course.durationHours,
                  level: course.difficultyLevel,
                ),
                const SizedBox(height: 8),
                _CoursePricing(
                  originalPrice: course.price,
                  discountedPrice: discountedPrice,
                  discountPercentage: course.discountPercentage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseThumbnail extends StatelessWidget {
  final String? url;

  const _CourseThumbnail({this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url != null
          ? Image.network(
        url!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}

class _CourseMetadata extends StatelessWidget {
  final int duration;
  final String level;

  const _CourseMetadata({required this.duration, required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 16),
        const SizedBox(width: 4),
        Text('$duration hours'),
        const SizedBox(width: 16),
        const Icon(Icons.signal_cellular_alt, size: 16),
        const SizedBox(width: 4),
        Text(level),
      ],
    );
  }
}

class _CoursePricing extends StatelessWidget {
  final double originalPrice;
  final double discountedPrice;
  final double discountPercentage;

  const _CoursePricing({
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (discountPercentage > 0) ...[
          Row(
            children: [
              Text(
                originalPrice.toCurrencyVND(),
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                discountedPrice.toCurrencyVND(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          _DiscountBadge(percentage: discountPercentage),
        ] else
          Text(
            originalPrice.toCurrencyVND(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
      ],
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final double percentage;

  const _DiscountBadge({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '-${percentage.toStringAsFixed(0)}%',
        style: TextStyle(
          color: Colors.red.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _PriceSummaryCard extends StatelessWidget {
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;

  const _PriceSummaryCard({
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _PriceRow(label: 'Original Price', amount: originalPrice),
          if (discountAmount > 0) ...[
            const SizedBox(height: 8),
            _PriceRow(
              label: 'Discount',
              amount: discountAmount,
              isDiscount: true,
            ),
          ],
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _PriceRow(
            label: 'Total',
            amount: finalPrice,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDiscount;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.isDiscount = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          isDiscount ? '- ${amount.toCurrencyVND()}' : amount.toCurrencyVND(),
          style: TextStyle(
            color: isDiscount ? Colors.green : (isTotal ? Colors.blue : null),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
}

class _VNPayMethodCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/VNPAY_id-sVSMjm2_0.png',
              width: 120,
              height: 60,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 60,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Thanh toán qua VNPAY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
