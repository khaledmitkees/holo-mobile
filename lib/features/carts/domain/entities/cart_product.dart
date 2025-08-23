import 'package:equatable/equatable.dart';

class CartProduct extends Equatable {
  final int productId;
  final int quantity;

  const CartProduct({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, quantity];
}
