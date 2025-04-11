part of 'payment_bloc.dart';

@immutable
sealed class PaymentState extends Equatable{}
final class PaymentInitial extends PaymentState{
  @override
  List<Object?> get props => [];
}
final class PaymentLoaded extends PaymentState{
  final Course course;
  final String? paymentUrl;
   PaymentLoaded({
    required this.course,
     this.paymentUrl
  });
  @override
  List<Object?> get props => [course,paymentUrl];
  PaymentLoaded copyWith({
    Course? course,
    String? paymentUrl
}){
    return PaymentLoaded(course: course ?? this.course,paymentUrl: paymentUrl ?? this.paymentUrl);
}
}
final class PaymentLoading extends PaymentState{
  @override
  List<Object?> get props =>[];
}
