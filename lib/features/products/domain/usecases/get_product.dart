import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';

class GetProduct {
  final ProductsRepository repository;

  GetProduct({required this.repository});

  Future<Product> call(int id) async {
    return await repository.getProduct(id);
  }
}
