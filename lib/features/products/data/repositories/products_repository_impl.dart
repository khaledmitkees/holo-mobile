import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/products/data/datasources/products_remote_data_source.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;
  final LoggerInterface _logger;

  ProductsRepositoryImpl({
    required ProductsRemoteDataSource remoteDataSource,
    required LoggerInterface logger,
  }) : _remoteDataSource = remoteDataSource,
       _logger = logger;

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _remoteDataSource.getProducts();
      return products;
    } on NetworkException {
      rethrow;
    } catch (e) {
      _logger.error('Repository: Failed to get products: $e');
      throw NetworkException(message: 'Failed to fetch products: $e');
    }
  }

  @override
  Future<Product> getProduct(int id) async {
    try {
      final product = await _remoteDataSource.getProduct(id);
      return product;
    } on NetworkException {
      rethrow;
    } catch (e) {
      _logger.error('Repository: Failed to get product $id: $e');
      throw NetworkException(message: 'Failed to fetch product: $e');
    }
  }
}
