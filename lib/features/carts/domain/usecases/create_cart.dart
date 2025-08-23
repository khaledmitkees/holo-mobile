import '../entities/cart.dart';
import '../repositories/carts_repository.dart';

class CreateCart {
  final CartsRepository repository;

  CreateCart({required this.repository});

  Future<Cart> call(int userId, List<Map<String, dynamic>> products) async {
    return await repository.createCart(userId, products);
  }
}
