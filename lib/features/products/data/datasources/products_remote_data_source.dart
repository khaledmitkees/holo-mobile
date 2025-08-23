import 'package:holo_mobile/core/network/http_client.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProduct(int id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final HttpClient _httpClient;

  const ProductsRemoteDataSourceImpl({required HttpClient httpClient})
    : _httpClient = httpClient;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _httpClient.get('/products');
    final List<dynamic> productsJson = response['products'] as List<dynamic>;
    return productsJson
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    final response = await _httpClient.get('/products/$id');
    return ProductModel.fromJson(response);
  }
}
