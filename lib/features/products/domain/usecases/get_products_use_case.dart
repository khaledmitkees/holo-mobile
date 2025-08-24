import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<Product>> call() async {
    return await _repository.getProducts();
  }
}
