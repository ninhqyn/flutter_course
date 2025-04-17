part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}
final class RemoveFromCart extends CartEvent{
  final int courseId;
  RemoveFromCart(this.courseId);
}
final class LoadCart extends CartEvent{}
final class AddToCart extends CartEvent{
  final int courseId;
  AddToCart(this.courseId);
}
final class ClearCart extends CartEvent{}