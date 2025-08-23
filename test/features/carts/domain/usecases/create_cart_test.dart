import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';
import 'package:holo_mobile/features/carts/domain/usecases/create_cart.dart';

import 'create_cart_test.mocks.dart';

@GenerateMocks([CartsRepository])
void main() {
  group('CreateCart', () {
    late MockCartsRepository mockRepository;
    late CreateCart usecase;

    setUp(() {
      mockRepository = MockCartsRepository();
      usecase = CreateCart(repository: mockRepository);
    });

    test('should create cart via the repository', () async {
      // arrange
      const tUserId = 1;
      final tProducts = [
        {'productId': 1, 'quantity': 4}
      ];
      final tCart = Cart(
        id: 1,
        userId: 1,
        date: DateTime.parse('2020-03-02T00:00:00.000Z'),
        products: [
          const CartProduct(productId: 1, quantity: 4),
        ],
      );
      when(mockRepository.createCart(tUserId, tProducts)).thenAnswer((_) async => tCart);

      // act
      final result = await usecase(tUserId, tProducts);

      // assert
      expect(result, equals(tCart));
      verify(mockRepository.createCart(tUserId, tProducts));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
