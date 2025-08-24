import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:holo_mobile/features/carts/data/datasources/cart_local_data_source.dart';
import 'package:holo_mobile/core/storage/shared_preferences_interface.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/carts/data/models/cart_model.dart';

import 'cart_local_data_source_test.mocks.dart';

@GenerateMocks([LocalStorageInterface])
void main() {
  group('CartLocalDataSourceImpl', () {
    late CartLocalDataSourceImpl cartStorage;
    late MockLocalStorageInterface mockPrefs;

    setUp(() {
      mockPrefs = MockLocalStorageInterface();
      cartStorage = CartLocalDataSourceImpl(mockPrefs);
    });

    final tCart = Cart(
      id: 1,
      userId: 1,
      date: DateTime.parse('2020-03-02T00:00:00.000Z'),
      products: const [
        CartProduct(productId: 1, quantity: 4),
        CartProduct(productId: 2, quantity: 1),
      ],
    );

    group('saveCart', () {
      test('should save cart to SharedPreferences', () async {
        // arrange
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        // act
        await cartStorage.saveCart(tCart);

        // assert
        final expectedJson = jsonEncode(CartModel.fromEntity(tCart).toJson());
        verify(mockPrefs.setString('cached_cart', expectedJson));
      });

      test('should handle errors gracefully when saving cart', () async {
        // arrange
        when(mockPrefs.setString(any, any)).thenThrow(Exception('Error'));

        // act & assert
        expect(() => cartStorage.saveCart(tCart), returnsNormally);
      });
    });

    group('loadCart', () {
      test('should return cart from SharedPreferences', () async {
        // arrange
        final cartModel = CartModel.fromEntity(tCart);
        final cartJson = jsonEncode(cartModel.toJson());
        when(mockPrefs.getString('cached_cart')).thenAnswer((_) async => cartJson);

        // act
        final result = await cartStorage.loadCart();

        // assert
        expect(result, isNotNull);
        expect(result!.id, equals(tCart.id));
        expect(result.userId, equals(tCart.userId));
        expect(result.products.length, equals(tCart.products.length));
      });

      test('should return null when cart not found', () async {
        // arrange
        when(mockPrefs.getString('cached_cart')).thenAnswer((_) async => null);

        // act
        final result = await cartStorage.loadCart();

        // assert
        expect(result, isNull);
      });

      test('should return null when error occurs', () async {
        // arrange
        when(mockPrefs.getString('cached_cart')).thenThrow(Exception('Error'));

        // act
        final result = await cartStorage.loadCart();

        // assert
        expect(result, isNull);
      });
    });

    group('clearCart', () {
      test('should clear cart from SharedPreferences', () async {
        // arrange
        when(mockPrefs.remove('cached_cart')).thenAnswer((_) async => true);

        // act
        await cartStorage.clearCart();

        // assert
        verify(mockPrefs.remove('cached_cart'));
      });

      test('should handle errors gracefully when clearing cart', () async {
        // arrange
        when(mockPrefs.remove('cached_cart')).thenThrow(Exception('Error'));

        // act & assert
        expect(() => cartStorage.clearCart(), returnsNormally);
      });
    });

    group('Integration tests', () {
      test('should save and load cart correctly', () async {
        // arrange
        final cartModel = CartModel.fromEntity(tCart);
        final cartJson = jsonEncode(cartModel.toJson());
        when(mockPrefs.setString('cached_cart', cartJson)).thenAnswer((_) async => true);
        when(mockPrefs.getString('cached_cart')).thenAnswer((_) async => cartJson);

        // act
        await cartStorage.saveCart(tCart);
        final loadedCart = await cartStorage.loadCart();

        // assert
        expect(loadedCart, isNotNull);
        expect(loadedCart!.id, equals(tCart.id));
        expect(loadedCart.userId, equals(tCart.userId));
      });

      test('should clear cart data', () async {
        // arrange
        when(mockPrefs.remove('cached_cart')).thenAnswer((_) async => true);
        when(mockPrefs.getString('cached_cart')).thenAnswer((_) async => null);

        // act
        await cartStorage.clearCart();
        final loadedCart = await cartStorage.loadCart();

        // assert
        expect(loadedCart, isNull);
      });
    });
  });
}
