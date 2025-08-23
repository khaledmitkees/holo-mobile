import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_product.dart';

import 'get_product_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  group('GetProduct', () {
    late MockProductsRepository mockRepository;
    late GetProduct usecase;

    setUp(() {
      mockRepository = MockProductsRepository();
      usecase = GetProduct(repository: mockRepository);
    });

    test('should get product from the repository', () async {
      // arrange
      const tProductId = 1;
      const tProduct = Product(
        id: 1,
        title: 'Test Product',
        price: 10.99,
        description: 'Test Description',
        category: 'Test Category',
        image: 'test_image.jpg',
      );
      when(mockRepository.getProduct(tProductId)).thenAnswer((_) async => tProduct);

      // act
      final result = await usecase(tProductId);

      // assert
      expect(result, equals(tProduct));
      verify(mockRepository.getProduct(tProductId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
