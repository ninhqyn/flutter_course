part of 'payment_history_bloc.dart';

@immutable
sealed class PaymentHistoryState {}

final class PaymentHistoryInitial extends PaymentHistoryState {}
final class PaymentHistoryLoading extends PaymentHistoryState{}
final class PaymentHistoryLoaded extends PaymentHistoryState{
  final List<PaymentModel> payments;
  final bool hasMax;
  PaymentHistoryLoaded({
    required this.payments,
    required this.hasMax
});
}
final class PaymentHistoryLoadMore extends PaymentHistoryState{
  final List<PaymentModel> payments;
  final bool hasMax;
  PaymentHistoryLoadMore({
    required this.payments,
    required this.hasMax
  });
}
