import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';

class GetAllProducts {
  final ProductsRepository repository;

  GetAllProducts({required this.repository});

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}
