part of 'payment_history_bloc.dart';

@immutable
sealed class PaymentHistoryEvent {}
final class FetchHistory extends PaymentHistoryEvent{
}
