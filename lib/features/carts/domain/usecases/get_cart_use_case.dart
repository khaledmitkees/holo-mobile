import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

class GetCartUseCase {
  final CartsRepository repository;

  GetCartUseCase({required this.repository});

  Future<Cart> call(int id) async {
    return await repository.getCart(id);
  }
}
