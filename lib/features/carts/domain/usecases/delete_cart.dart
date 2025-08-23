import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

class DeleteCart {
  final CartsRepository repository;

  DeleteCart({required this.repository});

  Future<void> call(int id) async {
    return await repository.deleteCart(id);
  }
}
