import '../../domain/entities/cart_product.dart';

class CartProductModel extends CartProduct {
  const CartProductModel({
    required super.productId,
    required super.quantity,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}
