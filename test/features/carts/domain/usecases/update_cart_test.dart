import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';
import 'package:holo_mobile/features/carts/domain/usecases/update_cart.dart';

import 'update_cart_test.mocks.dart';

@GenerateMocks([CartsRepository])
void main() {
  group('UpdateCart', () {
    late MockCartsRepository mockRepository;
    late UpdateCart usecase;

    setUp(() {
      mockRepository = MockCartsRepository();
      usecase = UpdateCart(repository: mockRepository);
    });

    test('should update cart via the repository', () async {
      // arrange
      const tCartId = 1;
      final tProducts = [
        {'productId': 1, 'quantity': 5}
      ];
      final tCart = Cart(
        id: 1,
        userId: 1,
        date: DateTime.parse('2020-03-02T00:00:00.000Z'),
        products: [
          const CartProduct(productId: 1, quantity: 5),
        ],
      );
      when(mockRepository.updateCart(tCartId, tProducts)).thenAnswer((_) async => tCart);

      // act
      final result = await usecase(tCartId, tProducts);

      // assert
      expect(result, equals(tCart));
      verify(mockRepository.updateCart(tCartId, tProducts));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
