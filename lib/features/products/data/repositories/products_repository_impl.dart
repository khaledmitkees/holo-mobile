import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/products/data/datasources/products_remote_data_source.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  const ProductsRepositoryImpl({
    required ProductsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      return await _remoteDataSource.getAllProducts();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch products: $e');
    }
  }

  @override
  Future<Product> getProduct(int id) async {
    try {
      return await _remoteDataSource.getProduct(id);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch product: $e');
    }
  }
}
