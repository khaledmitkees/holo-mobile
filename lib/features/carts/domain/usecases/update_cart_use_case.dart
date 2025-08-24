import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

class UpdateCartUseCase {
  final CartsRepository repository;

  UpdateCartUseCase({required this.repository});

  Future<Cart> call(int id, int productId, int quantity) async {
    return await repository.updateCartItem(id, productId, quantity);
  }
}
