part of 'payment_bloc.dart';

// Payment Event
@immutable
sealed class PaymentEvent {}

final class CheckOutSubmit extends PaymentEvent {}

final class LoadCheckOut extends PaymentEvent {}
