
import 'package:learning_app/src/shared/models/course.dart';  // Import your Course model

class CartItemModel {
  final int cartId;
  final int userId;
  final Course course;
  final DateTime? addedAt;
  final bool isActive;

  CartItemModel({
    required this.cartId,
    required this.userId,
    required this.course,
    this.addedAt,
    required this.isActive,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartId: json['cartId'],
      userId: json['userId'],
      course: Course.fromJson(json['course']),
      addedAt: json['addedAt'] != null ? DateTime.parse(json['addedAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'userId': userId,
      'course': course.toJson(),
      'addedAt': addedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }
}


// class CartSummary {
//   final int totalItems;
//   final double totalPrice;
//   final double totalDiscount;
//   final double finalPrice;
//
//   CartSummary({
//     required this.totalItems,
//     required this.totalPrice,
//     required this.totalDiscount,
//     required this.finalPrice,
//   });
//
//   factory CartSummary.fromJson(Map<String, dynamic> json) {
//     return CartSummary(
//       totalItems: json['totalItems'],
//       totalPrice: json['totalPrice'].toDouble(),
//       totalDiscount: json['totalDiscount'].toDouble(),
//       finalPrice: json['finalPrice'].toDouble(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'totalItems': totalItems,
//       'totalPrice': totalPrice,
//       'totalDiscount': totalDiscount,
//       'finalPrice': finalPrice,
//     };
//   }
//
//   // Helper method to calculate summary from a list of cart items
//   static CartSummary calculateFromItems(List<CartItemModel> items) {
//     int totalItems = items.length;
//     double totalPrice = 0;
//     double totalDiscount = 0;
//
//     for (var item in items) {
//       final price = item.course.price;
//       final discount = price * (item.course.discountPercentage / 100);
//
//       totalPrice += price;
//       totalDiscount += discount;
//     }
//
//     double finalPrice = totalPrice - totalDiscount;
//
//     return CartSummary(
//       totalItems: totalItems,
//       totalPrice: totalPrice,
//       totalDiscount: totalDiscount,
//       finalPrice: finalPrice,
//     );
//   }
// }