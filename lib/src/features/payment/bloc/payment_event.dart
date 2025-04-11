part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

final class CheckOutSubmit extends PaymentEvent{
  final Course course;
  CheckOutSubmit({required this.course});
}
