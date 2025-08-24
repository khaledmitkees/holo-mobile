import 'package:equatable/equatable.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {
  const ProductDetailsInitial();
}

class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

class ProductDetailsLoaded extends ProductDetailsState {
  final Product product;
  final bool isLoading;

  const ProductDetailsLoaded({required this.product, this.isLoading = false});

  @override
  List<Object> get props => [product, isLoading];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductAddedToCart extends ProductDetailsState {
  final Product product;

  const ProductAddedToCart(this.product);

  @override
  List<Object> get props => [product];
}

class AddToCartError extends ProductDetailsState {
  final String message;
  final Product product;

  const AddToCartError({required this.message, required this.product});

  @override
  List<Object> get props => [message, product];
}
