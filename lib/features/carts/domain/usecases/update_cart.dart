import '../entities/cart.dart';
import '../repositories/carts_repository.dart';

class UpdateCart {
  final CartsRepository repository;

  UpdateCart({required this.repository});

  Future<Cart> call(int id, List<Map<String, dynamic>> products) async {
    return await repository.updateCart(id, products);
  }
}
