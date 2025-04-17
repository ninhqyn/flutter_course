import 'package:learning_app/src/data/model/cart_item_model.dart';
import 'package:learning_app/src/data/model/cart_response.dart';
import 'package:learning_app/src/data/services/cart_service.dart';

class CartRepository {
  final CartService _cartService;

  CartRepository(this._cartService);

  /// Get all active cart items for the current user
  Future<List<CartItemModel>> getCartItems() async {
    try {
      return await _cartService.getCartItems();
    } catch (e) {
      // You might want to handle specific errors or log them
      rethrow;
    }
  }

  /// Add a course to the cart
  Future<ApiResponse> addCourseToCart(int courseId) async {
    try {
      return await _cartService.addToCart(courseId);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to add course to cart',
        error: e.toString(),
      );
    }
  }

  /// Remove a course from the cart
  Future<ApiResponse> removeCourseFromCart(int courseId) async {
    try {
      return await _cartService.removeFromCart(courseId);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to remove course from cart',
        error: e.toString(),
      );
    }
  }

  /// Clear all items from the cart
  Future<ApiResponse> clearCart() async {
    try {
      return await _cartService.clearCart();
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to clear cart',
        error: e.toString(),
      );
    }
  }

  /// Check if a course is already in the cart
  Future<bool> isCourseInCart(int courseId) async {
    try {
      return await _cartService.isCourseInCart(courseId);
    } catch (e) {
      // Default to false if there's an error checking
      return false;
    }
  }
}