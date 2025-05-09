part of 'payment_history_bloc.dart';

@immutable
sealed class PaymentHistoryState {}

final class PaymentHistoryInitial extends PaymentHistoryState {}
final class PaymentHistoryLoading extends PaymentHistoryState{}
final class PaymentHistoryLoaded extends PaymentHistoryState{
  final List<PaymentModel> payments;

  PaymentHistoryLoaded({
    required this.payments
});
}
