import 'package:holo_mobile/features/carts/domain/entities/cart.dart';

abstract class CartsRepository {
  Future<Cart> getCart(int id);
  Future<Cart> createCartWithItem(int productId, int quantity);
  Future<Cart> updateCartItem(int id, int productId, int quantity);
  Future<void> deleteCart(int id);
  Future<void> addToCart(int productId, int quantity);
}
