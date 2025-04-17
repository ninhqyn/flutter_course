part of 'payment_bloc.dart';

// Payment State
@immutable
sealed class PaymentState extends Equatable {}

final class PaymentInitial extends PaymentState {
  @override
  List<Object?> get props => [];
}

final class PaymentLoading extends PaymentState {
  @override
  List<Object?> get props => [];
}

final class PaymentLoaded extends PaymentState {
  final String? paymentUrl;
  final double originalPrice;
  final double discountedPrice;
  final double discountAmount;

  PaymentLoaded({
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountAmount,
    this.paymentUrl
  });

  @override
  List<Object?> get props => [
    originalPrice,
    discountedPrice,
    discountAmount,
    paymentUrl
  ];

  PaymentLoaded copyWith({
    String? paymentUrl,
    double? originalPrice,
    double? discountedPrice,
    double? discountAmount,

  }) {
    return PaymentLoaded(
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      paymentUrl: paymentUrl ?? this.paymentUrl
    );
  }
}

final class PaymentError extends PaymentState {
  final String message;

  PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}
