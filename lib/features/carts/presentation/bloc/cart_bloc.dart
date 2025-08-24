import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/features/carts/domain/usecases/get_cart_use_case.dart';
import 'package:holo_mobile/features/carts/domain/usecases/update_cart_use_case.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_product_use_case.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCart;
  final UpdateCartUseCase _updateCart;
  final GetProductUseCase _getProduct;
  final LoggerInterface _logger;

  CartBloc({
    required GetCartUseCase getCart,
    required UpdateCartUseCase updateCart,
    required GetProductUseCase getProduct,
    required LoggerInterface logger,
  })  : _getCart = getCart,
        _updateCart = updateCart,
        _getProduct = getProduct,
        _logger = logger,
        super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<ClearCart>(_onClearCart);
    on<ClearCartError>(_onClearCartError);
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());

    try {
      final cart = await _getCart(1); // Using userId 1 for demo
      
      if (cart.products.isEmpty) {
        emit(const CartEmpty());
        return;
      }

      // Fetch product details for each cart item
      final List<Product> products = [];
      double total = 0.0;

      for (final cartProduct in cart.products) {
        try {
          final product = await _getProduct(cartProduct.productId);
          products.add(product);
          total += product.price * cartProduct.quantity;
        } catch (e) {
          _logger.error('Failed to load product ${cartProduct.productId}: $e');
        }
      }

      emit(CartLoaded(
        cart: cart,
        products: products,
        total: total,
      ));
    } catch (error) {
      _logger.error('Failed to load cart: $error');
      emit(CartError(error.toString()));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(currentState.copyWith(isUpdating: true));

    try {
      final cart = currentState.cart;
      if (cart == null) return;

      // If quantity is 0, remove the item
      if (event.quantity <= 0) {
        final updatedProducts = cart.products
            .where((cartProduct) => cartProduct.productId != event.productId)
            .toList();

        // If no products left, show empty state
        if (updatedProducts.isEmpty) {
          await _updateCart(cart.id, event.productId, 0);
          emit(const CartEmpty());
          return;
        }

        final updatedCart = Cart(
          id: cart.id,
          userId: cart.userId,
          date: cart.date,
          products: updatedProducts,
        );

        await _updateCart(updatedCart.id, event.productId, 0);

        // Remove the product from the products list and recalculate total
        final updatedProductsList = currentState.products
            .where((product) => product.id != event.productId)
            .toList();

        double total = 0.0;
        for (final product in updatedProductsList) {
          final cartProduct = updatedProducts.firstWhere(
            (cp) => cp.productId == product.id,
          );
          total += product.price * cartProduct.quantity;
        }

        emit(currentState.copyWith(
          cart: updatedCart,
          products: updatedProductsList,
          total: total,
          isUpdating: false,
        ));
        return;
      }

      // Update the cart item quantity
      final updatedProducts = cart.products.map((cartProduct) {
        if (cartProduct.productId == event.productId) {
          return CartProduct(
            productId: cartProduct.productId,
            quantity: event.quantity,
          );
        }
        return cartProduct;
      }).toList();

      final updatedCart = Cart(
        id: cart.id,
        userId: cart.userId,
        date: cart.date,
        products: updatedProducts,
      );

      await _updateCart(updatedCart.id, event.productId, event.quantity);

      // Recalculate total
      double total = 0.0;
      for (int i = 0; i < currentState.products.length; i++) {
        final product = currentState.products[i];
        final cartProduct = updatedProducts.firstWhere(
          (cp) => cp.productId == product.id,
        );
        total += product.price * cartProduct.quantity;
      }

      emit(currentState.copyWith(
        cart: updatedCart,
        total: total,
        isUpdating: false,
      ));
    } catch (error) {
      _logger.error('Failed to update cart item quantity: $error');
      emit(currentState.copyWith(
        isUpdating: false,
        errorMessage: 'Failed to update cart item',
      ));
    }
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(currentState.copyWith(isUpdating: true));

    try {
      final cart = currentState.cart;
      if (cart == null) return;

      // Remove the cart item
      final updatedProducts = cart.products
          .where((cartProduct) => cartProduct.productId != event.productId)
          .toList();

      if (updatedProducts.isEmpty) {
        emit(const CartEmpty());
        return;
      }

      final updatedCart = Cart(
        id: cart.id,
        userId: cart.userId,
        date: cart.date,
        products: updatedProducts,
      );

      await _updateCart(updatedCart.id, event.productId, 0);

      // Remove product from products list and recalculate total
      final updatedProductsList = currentState.products
          .where((product) => product.id != event.productId)
          .toList();

      double total = 0.0;
      for (int i = 0; i < updatedProductsList.length; i++) {
        final product = updatedProductsList[i];
        final cartProduct = updatedProducts.firstWhere(
          (cp) => cp.productId == product.id,
        );
        total += product.price * cartProduct.quantity;
      }

      emit(CartLoaded(
        cart: updatedCart,
        products: updatedProductsList,
        total: total,
        isUpdating: false,
      ));
    } catch (error) {
      _logger.error('Failed to remove cart item: $error');
      emit(currentState.copyWith(isUpdating: false));
      emit(CartError(error.toString()));
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(currentState.copyWith(isUpdating: true));

    try {
      final cart = currentState.cart;
      if (cart == null) return;

      // Clear cart by setting all products to 0 quantity
      for (final cartProduct in cart.products) {
        await _updateCart(cart.id, cartProduct.productId, 0);
      }
      emit(const CartEmpty());
    } catch (error) {
      _logger.error('Failed to clear cart: $error');
      emit(currentState.copyWith(
        isUpdating: false,
        errorMessage: 'Failed to clear cart. Please try again.',
      ));
    }
  }

  void _onClearCartError(
    ClearCartError event,
    Emitter<CartState> emit,
  ) {
    final currentState = state;
    if (currentState is CartLoaded && currentState.errorMessage != null) {
      emit(currentState.clearError());
    }
  }
}
