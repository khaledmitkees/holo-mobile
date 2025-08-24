import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

class AddToCartUseCase {
  final CartsRepository repository;

  const AddToCartUseCase({required this.repository});

  Future<void> call(int productId, int quantity) async {
    return await repository.addToCart(productId, quantity);
  }
}
