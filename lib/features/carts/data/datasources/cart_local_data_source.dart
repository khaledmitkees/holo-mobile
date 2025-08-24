import 'dart:convert';
import 'package:holo_mobile/core/storage/shared_preferences_interface.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/data/models/cart_model.dart';

abstract class CartLocalDataSource {
  Future<void> saveCart(Cart cart);
  Future<Cart?> loadCart();
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final LocalStorageInterface _localStorage;
  static const String _cartKey = 'cached_cart';

  CartLocalDataSourceImpl(this._localStorage);

  @override
  Future<void> saveCart(Cart cart) async {
    try {
      final cartModel = CartModel.fromEntity(cart);
      final cartJson = jsonEncode(cartModel.toJson());
      await _localStorage.setString(_cartKey, cartJson);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<Cart?> loadCart() async {
    try {
      final cartJson = await _localStorage.getString(_cartKey);
      if (cartJson != null) {
        final cartMap = jsonDecode(cartJson) as Map<String, dynamic>;
        final cartModel = CartModel.fromJson(cartMap);
        return cartModel.toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _localStorage.remove(_cartKey);
    } catch (e) {
      // Silently fail
    }
  }
}
