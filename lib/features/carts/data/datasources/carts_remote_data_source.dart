import 'package:holo_mobile/core/network/http_client.dart';
import '../models/cart_model.dart';

abstract class CartsRemoteDataSource {
  Future<CartModel> getCart(int id);
  Future<CartModel> createCart(int userId, List<Map<String, dynamic>> products);
  Future<CartModel> updateCart(int id, List<Map<String, dynamic>> products);
  Future<void> deleteCart(int id);
}

class CartsRemoteDataSourceImpl implements CartsRemoteDataSource {
  final HttpClient _httpClient;

  const CartsRemoteDataSourceImpl({required HttpClient httpClient})
    : _httpClient = httpClient;

  @override
  Future<CartModel> getCart(int id) async {
    final response = await _httpClient.get('/carts/$id');
    return CartModel.fromJson(response);
  }

  @override
  Future<CartModel> createCart(
    int userId,
    List<Map<String, dynamic>> products,
  ) async {
    final response = await _httpClient.post(
      '/carts',
      data: {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'products': products,
      },
    );
    return CartModel.fromJson(response);
  }

  @override
  Future<CartModel> updateCart(
    int id,
    List<Map<String, dynamic>> products,
  ) async {
    final response = await _httpClient.put(
      '/carts/$id',
      data: {
        'userId': 1, // This would typically come from user session
        'date': DateTime.now().toIso8601String(),
        'products': products,
      },
    );
    return CartModel.fromJson(response);
  }

  @override
  Future<void> deleteCart(int id) async {
    await _httpClient.delete('/carts/$id');
  }
}
