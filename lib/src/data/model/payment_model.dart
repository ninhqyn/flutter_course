
import 'package:learning_app/src/data/model/payment_detail_model.dart';

class PaymentModel {
  int paymentId;
  int userId;
  double amount;
  String? paymentStatus;
  String? paymentMethod;
  String? transactionId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? discountId;
  double? discountAmount;
  List<PaymentDetailModel>? paymentDetails;

  PaymentModel({
    required this.paymentId,
    required this.userId,
    required this.amount,
    this.paymentStatus,
    this.paymentMethod,
    this.transactionId,
    this.createdAt,
    this.updatedAt,
    this.discountId,
    this.discountAmount,
    this.paymentDetails,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['paymentId'],
      userId: json['userId'],
      amount: (json['amount'] as num).toDouble(),
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
      discountId: json['discountId'],
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      paymentDetails: (json['paymentDetails'] as List?)?.map((e) => PaymentDetailModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'userId': userId,
      'amount': amount,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'discountId': discountId,
      'discountAmount': discountAmount,
      'paymentDetails': paymentDetails?.map((e) => e.toJson()).toList(),
    };
  }
}

