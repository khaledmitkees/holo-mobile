import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProduct {
  final ProductsRepository repository;

  GetProduct({required this.repository});

  Future<Product> call(int id) async {
    return await repository.getProduct(id);
  }
}
