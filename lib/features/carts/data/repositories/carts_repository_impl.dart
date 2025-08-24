import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/carts/data/datasources/cart_local_data_source.dart';
import 'package:holo_mobile/features/carts/data/datasources/carts_remote_data_source.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

class CartsRepositoryImpl implements CartsRepository {
  final CartLocalDataSource _cartLocalDataSource;
  final CartsRemoteDataSource _remoteDataSource;

  CartsRepositoryImpl({
    required CartLocalDataSource cartLocalDataSource,
    required CartsRemoteDataSource remoteDataSource,
  }) : _cartLocalDataSource = cartLocalDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<Cart> getCart(int id) async {
    try {
      final cart = await _remoteDataSource.getCart(id);

      await _cartLocalDataSource.saveCart(cart);

      return cart;
    } on NetworkException {
      final savedCart = await _cartLocalDataSource.loadCart();
      if (savedCart != null && savedCart.id == id) {
        return savedCart;
      }
      rethrow;
    } catch (e) {
      final savedCart = await _cartLocalDataSource.loadCart();
      if (savedCart != null && savedCart.id == id) {
        return savedCart;
      }
      throw NetworkException(message: 'Failed to fetch cart: $e');
    }
  }

  @override
  Future<Cart> createCartWithItem(int productId, int quantity) async {
    try {
      final products = [
        {'productId': productId, 'quantity': quantity},
      ];

      final cart = await _remoteDataSource.createCart(1, products);

      await _cartLocalDataSource.saveCart(cart);

      return cart;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to create cart: $e');
    }
  }

  @override
  Future<Cart> updateCartItem(int id, int productId, int quantity) async {
    try {
      final existingCart = await _cartLocalDataSource.loadCart();
      if (existingCart == null) {
        final remoteCart = await _remoteDataSource.getCart(id);
        await _cartLocalDataSource.saveCart(remoteCart);
        return await updateCartItem(id, productId, quantity); // Retry with saved cart
      }

      final updatedProducts =
          existingCart.products
              .map(
                (product) => {
                  'productId': product.productId,
                  'quantity': product.quantity,
                },
              )
              .toList();

      final existingIndex = updatedProducts.indexWhere(
        (product) => product['productId'] == productId,
      );

      if (quantity <= 0) {
        if (existingIndex != -1) {
          updatedProducts.removeAt(existingIndex);
        }
      } else {
        if (existingIndex != -1) {
          updatedProducts[existingIndex]['quantity'] = quantity;
        } else {
          updatedProducts.add({'productId': productId, 'quantity': quantity});
        }
      }

      if (updatedProducts.isEmpty) {
        // Create empty cart instead of deleting
        final emptyCart = Cart(
          id: existingCart.id,
          userId: existingCart.userId,
          date: existingCart.date,
          products: [],
        );
        await _cartLocalDataSource.saveCart(emptyCart);
        return emptyCart;
      }

      final cart = await _remoteDataSource.updateCart(id, updatedProducts);

      await _cartLocalDataSource.saveCart(cart);

      return cart;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to update cart item: $e');
    }
  }

  @override
  Future<void> deleteCart(int id) async {
    try {
      await _remoteDataSource.deleteCart(id);
      await _cartLocalDataSource.clearCart();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to delete cart: $e');
    }
  }

  @override
  Future<void> addToCart(int productId, int quantity) async {
    try {
      final existingCart = await _cartLocalDataSource.loadCart();
      if (existingCart != null) {
        final existingProduct = existingCart.products.firstWhere(
          (product) => product.productId == productId,
          orElse: () => throw StateError('Product not found'),
        );

        int newQuantity;
        try {
          newQuantity = existingProduct.quantity + quantity;
        } catch (e) {
          newQuantity = quantity;
        }

        await updateCartItem(existingCart.id, productId, newQuantity);
      } else {
        await createCartWithItem(productId, quantity);
      }
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to add to cart: $e');
    }
  }
}
