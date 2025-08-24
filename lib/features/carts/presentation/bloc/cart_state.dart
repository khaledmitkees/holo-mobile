import 'package:equatable/equatable.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final Cart? cart;
  final List<Product> products;
  final double total;
  final bool isUpdating;
  final String? errorMessage;

  const CartLoaded({
    this.cart,
    required this.products,
    required this.total,
    this.isUpdating = false,
    this.errorMessage,
  });

  @override
  List<Object> get props => [cart ?? 0, products, total, isUpdating, errorMessage ?? ''];

  CartLoaded copyWith({
    Cart? cart,
    List<Product>? products,
    double? total,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return CartLoaded(
      cart: cart ?? this.cart,
      products: products ?? this.products,
      total: total ?? this.total,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
    );
  }

  CartLoaded clearError() {
    return copyWith(errorMessage: null);
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

class CartEmpty extends CartState {
  const CartEmpty();
}
