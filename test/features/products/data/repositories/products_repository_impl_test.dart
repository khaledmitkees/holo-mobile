import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/products/data/datasources/products_remote_data_source.dart';
import 'package:holo_mobile/features/products/data/repositories/products_repository_impl.dart';
import 'package:holo_mobile/features/products/data/models/product_model.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';

import 'products_repository_impl_test.mocks.dart';

@GenerateMocks([ProductsRemoteDataSource])
void main() {
  group('ProductsRepositoryImpl', () {
    late MockProductsRemoteDataSource mockRemoteDataSource;
    late ProductsRepositoryImpl repository;

    setUp(() {
      mockRemoteDataSource = MockProductsRemoteDataSource();
      repository = ProductsRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    });

    final tProductModel = ProductModel.fromJson({
      'id': 1,
      'title': 'Test Product',
      'price': 109.95,
      'description': 'Test description',
      'category': 'electronics',
      'image': 'https://test.com/image.jpg',
      'rating': {'rate': 3.9, 'count': 120}
    });

    final tProductsList = [tProductModel];

    group('getAllProducts', () {
      test('should return products when remote data source call is successful', () async {
        // arrange
        when(mockRemoteDataSource.getAllProducts())
            .thenAnswer((_) async => tProductsList);

        // act
        final result = await repository.getAllProducts();

        // assert
        expect(result, isA<List<Product>>());
        expect(result.length, equals(1));
        expect(result[0].id, equals(1));
        expect(result[0].title, equals('Test Product'));
        verify(mockRemoteDataSource.getAllProducts());
      });

      test('should throw NetworkException when remote data source throws NetworkException', () async {
        // arrange
        when(mockRemoteDataSource.getAllProducts())
            .thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => repository.getAllProducts(),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should throw NetworkException when remote data source throws other exception', () async {
        // arrange
        when(mockRemoteDataSource.getAllProducts())
            .thenThrow(Exception('Some error'));

        // act & assert
        expect(
          () => repository.getAllProducts(),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('getProduct', () {
      const tProductId = 1;

      test('should return product when remote data source call is successful', () async {
        // arrange
        when(mockRemoteDataSource.getProduct(tProductId))
            .thenAnswer((_) async => tProductModel);

        // act
        final result = await repository.getProduct(tProductId);

        // assert
        expect(result, isA<Product>());
        expect(result.id, equals(1));
        expect(result.title, equals('Test Product'));
        verify(mockRemoteDataSource.getProduct(tProductId));
      });

      test('should throw NetworkException when remote data source throws NetworkException', () async {
        // arrange
        when(mockRemoteDataSource.getProduct(tProductId))
            .thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => repository.getProduct(tProductId),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should throw NetworkException when remote data source throws other exception', () async {
        // arrange
        when(mockRemoteDataSource.getProduct(tProductId))
            .thenThrow(Exception('Some error'));

        // act & assert
        expect(
          () => repository.getProduct(tProductId),
          throwsA(isA<NetworkException>()),
        );
      });
    });

  });
}
