part of 'payment_history_detail_bloc.dart';

@immutable
sealed class PaymentHistoryDetailState {}
final class PaymentHistoryDetailLoading extends PaymentHistoryDetailState{}
final class PaymentHistoryDetailError extends PaymentHistoryDetailState{
  final String message;

  PaymentHistoryDetailError(this.message);
}
final class PaymentHistoryDetailInitial extends PaymentHistoryDetailState {}
final class PaymentHistoryDetailLoaded extends PaymentHistoryDetailState{
  final List<Course> courses;
  final PaymentModel payments;

  PaymentHistoryDetailLoaded({
    required this.payments,
    required this.courses
});
}
