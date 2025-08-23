import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetAllProducts {
  final ProductsRepository repository;

  GetAllProducts({required this.repository});

  Future<List<Product>> call() async {
    return await repository.getAllProducts();
  }
}
