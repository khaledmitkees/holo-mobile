import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/core/network/http_client.dart';
import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/carts/data/datasources/carts_remote_data_source.dart';
import 'package:holo_mobile/features/carts/data/models/cart_model.dart';

import 'carts_remote_data_source_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  group('CartsRemoteDataSource', () {
    late MockHttpClient mockHttpClient;
    late CartsRemoteDataSourceImpl dataSource;

    setUp(() {
      mockHttpClient = MockHttpClient();
      dataSource = CartsRemoteDataSourceImpl(httpClient: mockHttpClient);
    });

    group('getCart', () {
      const tCartId = 1;
      final tCartJson = {
        'id': 1,
        'userId': 1,
        'date': '2020-03-02T00:00:00.000Z',
        'products': [
          {'productId': 1, 'quantity': 4},
          {'productId': 2, 'quantity': 1},
        ],
      };

      test('should return CartModel when call is successful', () async {
        // arrange
        when(
          mockHttpClient.get('/carts/$tCartId'),
        ).thenAnswer((_) async => tCartJson);

        // act
        final result = await dataSource.getCart(tCartId);

        // assert
        expect(result, isA<CartModel>());
        expect(result.id, equals(1));
        expect(result.userId, equals(1));
        expect(result.products.length, equals(2));
        verify(mockHttpClient.get('/carts/$tCartId'));
      });

      test('should throw NetworkException when http client throws', () async {
        // arrange
        when(
          mockHttpClient.get('/carts/$tCartId'),
        ).thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => dataSource.getCart(tCartId),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('createCart', () {
      const tUserId = 1;
      final tProducts = [
        {'productId': 1, 'quantity': 4},
      ];
      final tCartJson = {
        'id': 1,
        'userId': 1,
        'date': '2020-03-02T00:00:00.000Z',
        'products': [
          {'productId': 1, 'quantity': 4},
        ],
      };

      test('should return CartModel when call is successful', () async {
        // arrange
        when(
          mockHttpClient.post('/carts', data: anyNamed('data')),
        ).thenAnswer((_) async => tCartJson);

        // act
        final result = await dataSource.createCart(tUserId, tProducts);

        // assert
        expect(result, isA<CartModel>());
        expect(result.id, equals(1));
        expect(result.userId, equals(1));
        verify(mockHttpClient.post('/carts', data: anyNamed('data')));
      });

      test('should throw NetworkException when http client throws', () async {
        // arrange
        when(
          mockHttpClient.post('/carts', data: anyNamed('data')),
        ).thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => dataSource.createCart(tUserId, tProducts),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('updateCart', () {
      const tCartId = 1;
      final tProducts = [
        {'productId': 1, 'quantity': 5},
      ];
      final tCartJson = {
        'id': 1,
        'userId': 1,
        'date': '2020-03-02T00:00:00.000Z',
        'products': [
          {'productId': 1, 'quantity': 5},
        ],
      };

      test('should return CartModel when call is successful', () async {
        // arrange
        when(
          mockHttpClient.put('/carts/$tCartId', data: anyNamed('data')),
        ).thenAnswer((_) async => tCartJson);

        // act
        final result = await dataSource.updateCart(tCartId, tProducts);

        // assert
        expect(result, isA<CartModel>());
        expect(result.id, equals(1));
        expect(result.products[0].quantity, equals(5));
        verify(mockHttpClient.put('/carts/$tCartId', data: anyNamed('data')));
      });

      test('should throw NetworkException when http client throws', () async {
        // arrange
        when(
          mockHttpClient.put('/carts/$tCartId', data: anyNamed('data')),
        ).thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => dataSource.updateCart(tCartId, tProducts),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('deleteCart', () {
      const tCartId = 1;

      test('should complete successfully when call is successful', () async {
        // arrange
        when(
          mockHttpClient.delete('/carts/$tCartId'),
        ).thenAnswer((_) async => {});

        // act
        await dataSource.deleteCart(tCartId);

        // assert
        verify(mockHttpClient.delete('/carts/$tCartId'));
      });

      test('should throw NetworkException when http client throws', () async {
        // arrange
        when(
          mockHttpClient.delete('/carts/$tCartId'),
        ).thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => dataSource.deleteCart(tCartId),
          throwsA(isA<NetworkException>()),
        );
      });
    });
  });
}
