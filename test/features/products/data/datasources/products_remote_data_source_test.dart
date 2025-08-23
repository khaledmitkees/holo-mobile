import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/core/network/http_client.dart';
import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/products/data/datasources/products_remote_data_source.dart';
import 'package:holo_mobile/features/products/data/models/product_model.dart';

import 'products_remote_data_source_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  group('ProductsRemoteDataSource', () {
    late MockHttpClient mockHttpClient;
    late ProductsRemoteDataSourceImpl dataSource;

    setUp(() {
      mockHttpClient = MockHttpClient();
      dataSource = ProductsRemoteDataSourceImpl(httpClient: mockHttpClient);
    });

    group('getAllProducts', () {
      final tProductsList = [
        {
          'id': 1,
          'title': 'Test Product',
          'price': 109.95,
          'description': 'Test description',
          'category': 'electronics',
          'image': 'https://test.com/image.jpg',
          'rating': {'rate': 3.9, 'count': 120},
        },
        {
          'id': 2,
          'title': 'Test Product 2',
          'price': 22.3,
          'description': 'Test description 2',
          'category': 'clothing',
          'image': 'https://test.com/image2.jpg',
          'rating': {'rate': 4.1, 'count': 259},
        },
      ];

      final tProductsJson = <String, dynamic>{
        'products': tProductsList,
      };

      test(
        'should return list of ProductModel when call is successful',
        () async {
          // arrange
          when(
            mockHttpClient.get('/products'),
          ).thenAnswer((_) async => tProductsJson);

          // act
          final result = await dataSource.getAllProducts();

          // assert
          expect(result, isA<List<ProductModel>>());
          expect(result.length, equals(2));
          expect(result[0].id, equals(1));
          expect(result[0].title, equals('Test Product'));
          expect(result[1].id, equals(2));
          verify(mockHttpClient.get('/products'));
        },
      );

      test('should throw NetworkException when http client throws', () async {
        // arrange
        when(
          mockHttpClient.get('/products'),
        ).thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => dataSource.getAllProducts(),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('getProduct', () {
      const tProductId = 1;
      final tProductJson = {
        'id': 1,
        'title': 'Test Product',
        'price': 109.95,
        'description': 'Test description',
        'category': 'electronics',
        'image': 'https://test.com/image.jpg',
        'rating': {'rate': 3.9, 'count': 120},
      };

      test('should return ProductModel when call is successful', () async {
        // arrange
        when(
          mockHttpClient.get('/products/$tProductId'),
        ).thenAnswer((_) async => tProductJson);

        // act
        final result = await dataSource.getProduct(tProductId);

        // assert
        expect(result, isA<ProductModel>());
        expect(result.id, equals(1));
        expect(result.title, equals('Test Product'));
        verify(mockHttpClient.get('/products/$tProductId'));
      });

      test('should throw NetworkException when http client throws', () async {
        // arrange
        when(
          mockHttpClient.get('/products/$tProductId'),
        ).thenThrow(const NetworkException(message: 'Network error'));

        // act & assert
        expect(
          () => dataSource.getProduct(tProductId),
          throwsA(isA<NetworkException>()),
        );
      });
    });
  });
}
