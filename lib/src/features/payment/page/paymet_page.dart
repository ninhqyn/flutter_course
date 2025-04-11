import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/core/payment/vnpay/vnpay_service.dart';
import 'package:learning_app/src/data/model/result_model.dart';
import 'package:learning_app/src/data/repositories/auth_repository.dart';
import 'package:learning_app/src/features/payment/bloc/payment_bloc.dart';
import 'package:learning_app/src/features/payment/page/paymet_result.dart';
import 'package:learning_app/src/features/payment/page/vnpay_webview.dart';
import 'package:learning_app/src/shared/utils/price_format.dart';

import '../../../shared/models/course.dart';
class PaymentPage extends StatelessWidget {
  final Course course;

  const PaymentPage({super.key, required this.course});

  double get _discountedPrice {
    return course.price * (1 - course.discountPercentage / 100);
  }
  void _processPayment(BuildContext context) {
    context.read<PaymentBloc>().add(CheckOutSubmit(course: course));
  }
  void showPaymentResult(BuildContext context,ModelResult params) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentResult(result: params,),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => PaymentBloc(VnPayService(context.read<AuthRepository>())),
  child: Builder(
    builder: (context) {
      return BlocListener<PaymentBloc, PaymentState>(
  listener: (context, state) {
    if(state is PaymentLoaded){
      if(state.paymentUrl!=null){
        Navigator.push(context, MaterialPageRoute(builder: (_){
          return VnPayWebView(paymentUrl: state.paymentUrl!,
            onPaymentComplete: (params){
              showPaymentResult(context,params);
            },
          );
        }
        )

        );
      }
    }
  },
  child: Scaffold(
          appBar: AppBar(
            title: const Text('Checkout'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: course.thumbnailUrl != null
                            ? Image.network(
                          course.thumbnailUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image, color: Colors.grey),
                            );
                          },
                        )
                            : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Course details
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
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 4),
                                Text('${course.durationHours} hours'),
                                const SizedBox(width: 16),
                                const Icon(Icons.signal_cellular_alt, size: 16),
                                const SizedBox(width: 4),
                                Text(course.difficultyLevel),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 24),
      
                // Price summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Original Price'),
                          Text(course.price.toCurrencyVND()),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (course.discountPercentage > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount (${course.discountPercentage.toStringAsFixed(0)}%)'),
                            Text(
                              '- ${(course.price * course.discountPercentage / 100).toCurrencyVND()}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _discountedPrice.toCurrencyVND(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 24),
      
                // Payment method selection
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:Image.asset(
                          'assets/images/VNPAY_id-sVSMjm2_0.png',
                          width: 150,
                          height: 80,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image, color: Colors.grey),
                            );
                          },
                        )
                      ),
                      const SizedBox(width: 16),
                      // Course details
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
      
                ),
      
                const SizedBox(height: 60),
                // Checkout button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      _processPayment(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Pay ${(_discountedPrice).toCurrencyVND()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
);
    }
  ),
);
  }


}