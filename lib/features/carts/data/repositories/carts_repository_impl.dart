import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/carts/data/datasources/carts_remote_data_source.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

class CartsRepositoryImpl implements CartsRepository {
  final CartsRemoteDataSource _remoteDataSource;

  const CartsRepositoryImpl({required CartsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Cart> getCart(int id) async {
    try {
      return await _remoteDataSource.getCart(id);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to fetch cart: $e');
    }
  }

  @override
  Future<Cart> createCart(
    int userId,
    List<Map<String, dynamic>> products,
  ) async {
    try {
      return await _remoteDataSource.createCart(userId, products);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to create cart: $e');
    }
  }

  @override
  Future<Cart> updateCart(int id, List<Map<String, dynamic>> products) async {
    try {
      return await _remoteDataSource.updateCart(id, products);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to update cart: $e');
    }
  }

  @override
  Future<void> deleteCart(int id) async {
    try {
      await _remoteDataSource.deleteCart(id);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to delete cart: $e');
    }
  }
}
