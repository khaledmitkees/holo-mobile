import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/carts/data/datasources/cart_local_data_source.dart';
import 'package:holo_mobile/features/carts/data/datasources/carts_remote_data_source.dart';
import 'package:holo_mobile/features/carts/data/models/cart_model.dart';
import 'package:holo_mobile/features/carts/data/models/cart_product_model.dart';
import 'package:holo_mobile/features/carts/data/repositories/carts_repository_impl.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';

import 'carts_repository_impl_test.mocks.dart';

@GenerateMocks([CartsRemoteDataSource, CartLocalDataSource])
void main() {
  group('CartsRepositoryImpl', () {
    late MockCartsRemoteDataSource mockRemoteDataSource;
    late MockCartLocalDataSource mockCartLocalDataSource;
    late CartsRepositoryImpl repository;

    setUp(() {
      mockRemoteDataSource = MockCartsRemoteDataSource();
      mockCartLocalDataSource = MockCartLocalDataSource();
      repository = CartsRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        cartLocalDataSource: mockCartLocalDataSource,
      );

      // Setup default stubs for CartStorage
      when(mockCartLocalDataSource.loadCart()).thenAnswer((_) async => null);
      when(mockCartLocalDataSource.saveCart(any)).thenAnswer((_) async {});
      when(mockCartLocalDataSource.clearCart()).thenAnswer((_) async {});
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

      test(
        'should return cart when remote data source call is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getCart(tCartId),
          ).thenAnswer((_) async => tCartModel);

          // act
          final result = await repository.getCart(tCartId);

          // assert
          expect(result, isA<Cart>());
          expect(result.id, equals(1));
          expect(result.userId, equals(1));
          expect(result.products.length, equals(2));
          verify(mockRemoteDataSource.getCart(tCartId));
        },
      );

      test(
        'should throw NetworkException when remote data source throws NetworkException',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getCart(tCartId),
          ).thenThrow(const NetworkException(message: 'Network error'));

          // act & assert
          expect(
            () => repository.getCart(tCartId),
            throwsA(isA<NetworkException>()),
          );
        },
      );

      test(
        'should throw NetworkException when remote data source throws other exception',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getCart(tCartId),
          ).thenThrow(Exception('Some error'));

          // act & assert
          expect(
            () => repository.getCart(tCartId),
            throwsA(isA<NetworkException>()),
          );
        },
      );
    });

    group('createCartWithItem', () {
      const tProductId = 1;
      const tQuantity = 4;
      final tProducts = [
        {'productId': tProductId, 'quantity': tQuantity},
      ];

      test(
        'should return cart when remote data source call is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.createCart(1, tProducts),
          ).thenAnswer((_) async => tCartModel);

          // act
          final result = await repository.createCartWithItem(tProductId, tQuantity);

          // assert
          expect(result, isA<Cart>());
          expect(result.id, equals(1));
          expect(result.userId, equals(1));
          verify(mockRemoteDataSource.createCart(1, tProducts));
          verify(mockCartLocalDataSource.saveCart(any));
        },
      );

      test(
        'should throw NetworkException when remote data source throws NetworkException',
        () async {
          // arrange
          when(
            mockRemoteDataSource.createCart(1, tProducts),
          ).thenThrow(const NetworkException(message: 'Network error'));

          // act & assert
          expect(
            () => repository.createCartWithItem(tProductId, tQuantity),
            throwsA(isA<NetworkException>()),
          );
        },
      );

      test(
        'should throw NetworkException when remote data source throws other exception',
        () async {
          // arrange
          when(
            mockRemoteDataSource.createCart(1, tProducts),
          ).thenThrow(Exception('Some error'));

          // act & assert
          expect(
            () => repository.createCartWithItem(tProductId, tQuantity),
            throwsA(isA<NetworkException>()),
          );
        },
      );
    });

    group('updateCartItem', () {
      const tCartId = 1;
      const tProductId = 1;
      const tQuantity = 5;

      test(
        'should return updated cart when remote data source call is successful',
        () async {
          // arrange
          when(
            mockCartLocalDataSource.loadCart(),
          ).thenAnswer((_) async => tCartModel.toEntity());
          when(
            mockRemoteDataSource.updateCart(tCartId, any),
          ).thenAnswer((_) async => tCartModel);

          // act
          final result = await repository.updateCartItem(tCartId, tProductId, tQuantity);

          // assert
          expect(result, isA<Cart>());
          expect(result.id, equals(1));
          verify(mockCartLocalDataSource.loadCart());
          verify(mockRemoteDataSource.updateCart(tCartId, any));
          verify(mockCartLocalDataSource.saveCart(any));
        },
      );

      test(
        'should throw NetworkException when no existing cart found',
        () async {
          // arrange
          when(
            mockCartLocalDataSource.loadCart(),
          ).thenAnswer((_) async => null);

          // act & assert
          expect(
            () => repository.updateCartItem(tCartId, tProductId, tQuantity),
            throwsA(isA<NetworkException>()),
          );
        },
      );

      test(
        'should throw NetworkException when remote data source throws other exception',
        () async {
          // arrange
          when(
            mockCartLocalDataSource.loadCart(),
          ).thenAnswer((_) async => tCartModel.toEntity());
          when(
            mockRemoteDataSource.updateCart(tCartId, any),
          ).thenThrow(Exception('Some error'));

          // act & assert
          expect(
            () => repository.updateCartItem(tCartId, tProductId, tQuantity),
            throwsA(isA<NetworkException>()),
          );
        },
      );
    });

    group('deleteCart', () {
      const tCartId = 1;

      test(
        'should complete successfully when remote data source call is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.deleteCart(tCartId),
          ).thenAnswer((_) async => {});

          // act
          await repository.deleteCart(tCartId);

          // assert
          verify(mockRemoteDataSource.deleteCart(tCartId));
          verify(mockCartLocalDataSource.clearCart());
        },
      );

      test(
        'should throw NetworkException when remote data source throws NetworkException',
        () async {
          // arrange
          when(
            mockRemoteDataSource.deleteCart(tCartId),
          ).thenThrow(const NetworkException(message: 'Network error'));

          // act & assert
          expect(
            () => repository.deleteCart(tCartId),
            throwsA(isA<NetworkException>()),
          );
        },
      );

      test(
        'should throw NetworkException when remote data source throws other exception',
        () async {
          // arrange
          when(
            mockRemoteDataSource.deleteCart(tCartId),
          ).thenThrow(Exception('Some error'));

          // act & assert
          expect(
            () => repository.deleteCart(tCartId),
            throwsA(isA<NetworkException>()),
          );
        },
      );
    });

    group('addToCart', () {
      const tProductId = 1;
      const tQuantity = 2;
      final tProducts = [
        {'productId': tProductId, 'quantity': tQuantity},
      ];

      test('should create new cart when no existing cart in storage', () async {
        // arrange
        when(mockCartLocalDataSource.loadCart()).thenAnswer((_) async => null);
        when(
          mockRemoteDataSource.createCart(1, tProducts),
        ).thenAnswer((_) async => tCartModel);

        // act
        await repository.addToCart(tProductId, tQuantity);

        // assert
        verify(mockCartLocalDataSource.loadCart());
        verify(mockRemoteDataSource.createCart(1, tProducts));
        verify(mockCartLocalDataSource.saveCart(any));
      });

      test('should update existing cart when cart exists in storage', () async {
        // arrange
        final existingCart = tCartModel.toEntity();
        when(
          mockCartLocalDataSource.loadCart(),
        ).thenAnswer((_) async => existingCart);
        when(
          mockRemoteDataSource.updateCart(existingCart.id, any),
        ).thenAnswer((_) async => tCartModel);

        // act
        await repository.addToCart(tProductId, tQuantity);

        // assert
        verify(mockCartLocalDataSource.loadCart());
        verify(mockRemoteDataSource.updateCart(existingCart.id, any));
        verify(mockCartLocalDataSource.saveCart(any));
      });

      test(
        'should throw NetworkException when remote data source throws NetworkException',
        () async {
          // arrange
          when(
            mockCartLocalDataSource.loadCart(),
          ).thenAnswer((_) async => null);
          when(
            mockRemoteDataSource.createCart(1, tProducts),
          ).thenThrow(const NetworkException(message: 'Network error'));

          // act & assert
          expect(
            () => repository.addToCart(tProductId, tQuantity),
            throwsA(isA<NetworkException>()),
          );
        },
      );

      test(
        'should throw NetworkException when remote data source throws other exception',
        () async {
          // arrange
          when(
            mockCartLocalDataSource.loadCart(),
          ).thenAnswer((_) async => null);
          when(
            mockRemoteDataSource.createCart(1, tProducts),
          ).thenThrow(Exception('Some error'));

          // act & assert
          expect(
            () => repository.addToCart(tProductId, tQuantity),
            throwsA(isA<NetworkException>()),
          );
        },
      );
    });
  });
}
