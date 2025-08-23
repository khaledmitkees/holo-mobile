import '../entities/cart.dart';
import '../repositories/carts_repository.dart';

class GetCart {
  final CartsRepository repository;

  GetCart({required this.repository});

  Future<Cart> call(int id) async {
    return await repository.getCart(id);
  }
}
