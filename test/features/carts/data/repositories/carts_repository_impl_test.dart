import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/carts/data/datasources/carts_remote_data_source.dart';
import 'package:holo_mobile/features/carts/data/repositories/carts_repository_impl.dart';
import 'package:holo_mobile/features/carts/data/models/cart_model.dart';
import 'package:holo_mobile/features/carts/data/models/cart_product_model.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';

import 'carts_repository_impl_test.mocks.dart';

@GenerateMocks([CartsRemoteDataSource])
void main() {
  group('CartsRepositoryImpl', () {
    late MockCartsRemoteDataSource mockRemoteDataSource;
    late CartsRepositoryImpl repository;

    setUp(() {
      mockRemoteDataSource = MockCartsRemoteDataSource();
      repository = CartsRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    });

    final tCartModel = CartModel(
      id: 1,
      userId: 1,
      date: DateTime.parse('2020-03-02T00:00:00.000Z'),
      products: const [
        CartProductModel(productId: 1, quantity: 4),
        CartProductModel(productId: 2, quantity: 1),
      ],
    );



    group('getCart', () {
      const tCartId = 1;

      test('should return cart when remote data source call is successful', () async {
        // arrange
        when(mockRemoteDataSource.getCart(tCartId))
            .thenAnswer((_) async => tCartModel);

        // act
        final result = await repository.getCart(tCartId);

        // assert
        expect(result, isA<Cart>());
        expect(result.id, equals(1));
        expect(result.userId, equals(1));
        expect(result.products.length, equals(2));
        verify(mockRemoteDataSource.getCart(tCartId));
      });

      test('should throw NetworkException when remote data source throws NetworkException', () async {
        // arrange
        when(mockRemoteDataSource.getCart(tCartId))
            .thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => repository.getCart(tCartId),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should throw NetworkException when remote data source throws other exception', () async {
        // arrange
        when(mockRemoteDataSource.getCart(tCartId))
            .thenThrow(Exception('Some error'));

        // act & assert
        expect(
          () => repository.getCart(tCartId),
          throwsA(isA<NetworkException>()),
        );
      });
    });


    group('createCart', () {
      const tUserId = 1;
      final tProducts = [
        {'productId': 1, 'quantity': 4}
      ];

      test('should return cart when remote data source call is successful', () async {
        // arrange
        when(mockRemoteDataSource.createCart(tUserId, tProducts))
            .thenAnswer((_) async => tCartModel);

        // act
        final result = await repository.createCart(tUserId, tProducts);

        // assert
        expect(result, isA<Cart>());
        expect(result.id, equals(1));
        expect(result.userId, equals(1));
        verify(mockRemoteDataSource.createCart(tUserId, tProducts));
      });

      test('should throw NetworkException when remote data source throws NetworkException', () async {
        // arrange
        when(mockRemoteDataSource.createCart(tUserId, tProducts))
            .thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => repository.createCart(tUserId, tProducts),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should throw NetworkException when remote data source throws other exception', () async {
        // arrange
        when(mockRemoteDataSource.createCart(tUserId, tProducts))
            .thenThrow(Exception('Some error'));

        // act & assert
        expect(
          () => repository.createCart(tUserId, tProducts),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('updateCart', () {
      const tCartId = 1;
      final tProducts = [
        {'productId': 1, 'quantity': 5}
      ];

      test('should return updated cart when remote data source call is successful', () async {
        // arrange
        when(mockRemoteDataSource.updateCart(tCartId, tProducts))
            .thenAnswer((_) async => tCartModel);

        // act
        final result = await repository.updateCart(tCartId, tProducts);

        // assert
        expect(result, isA<Cart>());
        expect(result.id, equals(1));
        verify(mockRemoteDataSource.updateCart(tCartId, tProducts));
      });

      test('should throw NetworkException when remote data source throws NetworkException', () async {
        // arrange
        when(mockRemoteDataSource.updateCart(tCartId, tProducts))
            .thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => repository.updateCart(tCartId, tProducts),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should throw NetworkException when remote data source throws other exception', () async {
        // arrange
        when(mockRemoteDataSource.updateCart(tCartId, tProducts))
            .thenThrow(Exception('Some error'));

        // act & assert
        expect(
          () => repository.updateCart(tCartId, tProducts),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('deleteCart', () {
      const tCartId = 1;

      test('should complete successfully when remote data source call is successful', () async {
        // arrange
        when(mockRemoteDataSource.deleteCart(tCartId))
            .thenAnswer((_) async => {});

        // act
        await repository.deleteCart(tCartId);

        // assert
        verify(mockRemoteDataSource.deleteCart(tCartId));
      });

      test('should throw NetworkException when remote data source throws NetworkException', () async {
        // arrange
        when(mockRemoteDataSource.deleteCart(tCartId))
            .thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => repository.deleteCart(tCartId),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should throw NetworkException when remote data source throws other exception', () async {
        // arrange
        when(mockRemoteDataSource.deleteCart(tCartId))
            .thenThrow(Exception('Some error'));

        // act & assert
        expect(
          () => repository.deleteCart(tCartId),
          throwsA(isA<NetworkException>()),
        );
      });
    });
  });
}
