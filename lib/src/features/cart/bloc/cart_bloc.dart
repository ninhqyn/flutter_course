import 'package:bloc/bloc.dart';
import 'package:learning_app/src/data/model/cart_item_model.dart';
import 'package:learning_app/src/data/repositories/cart_repository.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  CartBloc(CartRepository cartRepository) :_cartRepository = cartRepository, super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<AddToCart>(_onAddToCart);
    on<ClearCart>(_onClearCart);
  }
  Future<void> _onLoadCart(LoadCart event,Emitter<CartState> emit) async{
    emit(CartLoading());
    final cartItems = await _cartRepository.getCartItems();
    emit(CartLoaded(cartItems: cartItems));
  }
  Future<void> _onRemoveFromCart(RemoveFromCart event,Emitter<CartState> emit) async{

    final result = await _cartRepository.removeCourseFromCart(event.courseId);
    if(result.success){
      final cartItems = await _cartRepository.getCartItems();
      emit(CartLoaded(cartItems: cartItems));
    }else{
    }

  }
  Future<void> _onAddToCart(AddToCart event,Emitter<CartState> emit) async{
    final result = await _cartRepository.addCourseToCart(event.courseId);
    if(result.success){
      emit(CartAdded(message: result.message ?? 'Item added to cart!'));
    }else{
      emit(CartAddError(result.error ?? 'Da them vo cart'));

    }
    final cartItems = await _cartRepository.getCartItems();
    emit(CartLoaded(cartItems: cartItems));

  }
  Future<void> _onClearCart(ClearCart event,Emitter<CartState> emit) async{
      await _cartRepository.clearCart();

      final cartItems = await _cartRepository.getCartItems();
      emit(CartLoaded(cartItems: cartItems));


  }
}
