import '../entities/cart.dart';

abstract class CartsRepository {
  Future<Cart> getCart(int id);
  Future<Cart> createCart(int userId, List<Map<String, dynamic>> products);
  Future<Cart> updateCart(int id, List<Map<String, dynamic>> products);
  Future<void> deleteCart(int id);
}
