import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

class UpdateCart {
  final CartsRepository repository;

  UpdateCart({required this.repository});

  Future<Cart> call(int id, List<Map<String, dynamic>> products) async {
    return await repository.updateCart(id, products);
  }
}
