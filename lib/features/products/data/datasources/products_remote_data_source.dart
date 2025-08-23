import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/core/network/http_client.dart';
import 'package:holo_mobile/features/products/data/models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProduct(int id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final HttpClient _httpClient;
  final LoggerInterface _logger;

  ProductsRemoteDataSourceImpl({
    required HttpClient httpClient,
    required LoggerInterface logger,
  }) : _httpClient = httpClient,
       _logger = logger;

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      _logger.info('Fetching products from API');
      final response = await _httpClient.get<List<dynamic>>('/products');
      
      return response
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.error('Failed to fetch products: $e');
      if (e is NetworkException) {
        rethrow;
      }
      throw const NetworkException(message: 'Failed to fetch products');
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>('/products/$id');
      final product = ProductModel.fromJson(response);
      return product;
    } catch (e) {
      _logger.error('Failed to fetch product $id: $e');
      if (e is NetworkException) {
        rethrow;
      }
      throw const NetworkException(message: 'Failed to fetch product');
    }
  }
}
