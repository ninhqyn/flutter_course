class PaymentDetailModel {
  int id;
  int paymentId;
  String itemType;
  int itemId;
  int? quantity;
  double unitPrice;
  double? discountAmount;
  double subtotal;
  DateTime? createdAt;

  PaymentDetailModel({
    required this.id,
    required this.paymentId,
    required this.itemType,
    required this.itemId,
    this.quantity,
    required this.unitPrice,
    this.discountAmount,
    required this.subtotal,
    this.createdAt,
  });

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      id: json['id'],
      paymentId: json['paymentId'],
      itemType: json['itemType'],
      itemId: json['itemId'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentId': paymentId,
      'itemType': itemType,
      'itemId': itemId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discountAmount': discountAmount,
      'subtotal': subtotal,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}