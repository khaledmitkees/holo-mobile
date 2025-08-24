import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';

class GetProductUseCase {
  final ProductsRepository repository;

  GetProductUseCase({required this.repository});

  Future<Product> call(int id) async {
    return await repository.getProduct(id);
  }
}
