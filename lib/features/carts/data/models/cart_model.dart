import 'package:holo_mobile/features/carts/domain/entities/cart.dart';

import 'cart_product_model.dart';

class CartModel extends Cart {
  const CartModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: json['date'] != null 
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      products:
          (json['products'] as List<dynamic>)
              .map(
                (product) =>
                    CartProductModel.fromJson(product as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'products':
          products
              .map((product) => (product as CartProductModel).toJson())
              .toList(),
    };
  }

  factory CartModel.fromEntity(Cart cart) {
    return CartModel(
      id: cart.id,
      userId: cart.userId,
      date: cart.date,
      products: cart.products
          .map((product) => CartProductModel(
                productId: product.productId,
                quantity: product.quantity,
              ))
          .toList(),
    );
  }

  Cart toEntity() {
    return Cart(
      id: id,
      userId: userId,
      date: date,
      products: products,
    );
  }
}
