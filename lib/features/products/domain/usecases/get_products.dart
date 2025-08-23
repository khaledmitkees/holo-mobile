import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProducts {
  final ProductsRepository _repository;

  GetProducts(this._repository);

  Future<List<Product>> call() async {
    return await _repository.getProducts();
  }
}
