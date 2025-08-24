import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadProductDetails extends ProductDetailsEvent {
  final int productId;

  const LoadProductDetails(this.productId);

  @override
  List<Object> get props => [productId];
}

class AddProductToCart extends ProductDetailsEvent {
  final int productId;
  final int quantity;

  const AddProductToCart({
    required this.productId,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [productId, quantity];
}
