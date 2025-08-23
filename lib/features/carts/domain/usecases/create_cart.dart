import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

class CreateCart {
  final CartsRepository repository;

  CreateCart({required this.repository});

  Future<Cart> call(int userId, List<Map<String, dynamic>> products) async {
    return await repository.createCart(userId, products);
  }
}
