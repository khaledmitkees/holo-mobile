import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProduct(int id);
}
