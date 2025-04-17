part of 'cart_bloc.dart';

@immutable
sealed class CartState {}
final class CartInitial extends CartState {}
final class CartLoading extends CartState{}
final class CartLoaded extends CartState{
  final List<CartItemModel> cartItems;

  CartLoaded({required this.cartItems});
}
final class CartError extends CartState{
  final String message;

  CartError({required this.message});
}
final class CartAdded extends CartState{
  final String message;
  CartAdded({required this.message});
}
final class CartAddError extends CartState{
  final String message;
  CartAddError(this.message);
}