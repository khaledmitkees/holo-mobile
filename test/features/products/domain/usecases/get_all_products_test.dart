import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_all_products.dart';

import 'get_all_products_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  group('GetAllProducts', () {
    late MockProductsRepository mockRepository;
    late GetAllProducts usecase;

    setUp(() {
      mockRepository = MockProductsRepository();
      usecase = GetAllProducts(repository: mockRepository);
    });

    test('should get all products from the repository', () async {
      // arrange
      final tProducts = [
        const Product(
          id: 1,
          title: 'Test Product 1',
          price: 10.99,
          description: 'Test Description 1',
          category: 'Test Category',
          image: 'test_image_1.jpg',
        ),
        const Product(
          id: 2,
          title: 'Test Product 2',
          price: 20.99,
          description: 'Test Description 2',
          category: 'Test Category',
          image: 'test_image_2.jpg',
        ),
      ];
      when(mockRepository.getAllProducts()).thenAnswer((_) async => tProducts);

      // act
      final result = await usecase();

      // assert
      expect(result, equals(tProducts));
      verify(mockRepository.getAllProducts());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
