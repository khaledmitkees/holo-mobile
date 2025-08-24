import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class UpdateCartItemQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateCartItemQuantity({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, quantity];
}

class RemoveCartItem extends CartEvent {
  final int productId;

  const RemoveCartItem(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class ClearCartError extends CartEvent {
  const ClearCartError();
}
