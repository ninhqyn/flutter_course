part of 'cart_bloc.dart';

@immutable
sealed class CartState extends Equatable{}
final class CartInitial extends CartState {
  @override
  List<Object?> get props => [];
}
final class CartLoading extends CartState{
  @override
  List<Object?> get props => [];
}
final class CartLoaded extends CartState{
  final List<CartItemModel> cartItems;
  final List<Course> courses;
  final double totalPrice;
  CartLoaded({required this.cartItems,required this.courses,required this.totalPrice});
  @override
  List<Object?> get props => [cartItems,courses,totalPrice];
  CartLoaded copyWith(
      List<CartItemModel>? cartItems,
      List<Course>? courses,
      double? totalPrice
      ){
    return CartLoaded(
        cartItems:cartItems ?? this.cartItems,
        courses: courses ?? this.courses,
        totalPrice: totalPrice ?? this.totalPrice);
  }
}
final class CartError extends CartState{
  final String message;

  CartError({required this.message});
  @override
  List<Object?> get props => [];
}
final class CartAdded extends CartState{
  final String message;
  CartAdded({required this.message});
  @override
  List<Object?> get props => [];
}
final class CartAddError extends CartState{
  final String message;
  CartAddError(this.message);
  @override
  List<Object?> get props => [];
}