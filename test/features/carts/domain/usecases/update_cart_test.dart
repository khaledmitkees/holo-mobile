import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';
import 'package:holo_mobile/features/carts/domain/usecases/update_cart_use_case.dart';

import 'update_cart_test.mocks.dart';

@GenerateMocks([CartsRepository])
void main() {
  group('UpdateCartUseCase', () {
    late MockCartsRepository mockRepository;
    late UpdateCartUseCase usecase;

    setUp(() {
      mockRepository = MockCartsRepository();
      usecase = UpdateCartUseCase(repository: mockRepository);
    });

    test('should update cart item via the repository', () async {
      // arrange
      const tCartId = 1;
      const tProductId = 1;
      const tQuantity = 5;
      final tCart = Cart(
        id: 1,
        userId: 1,
        date: DateTime.parse('2020-03-02T00:00:00.000Z'),
        products: [
          const CartProduct(productId: 1, quantity: 5),
        ],
      );
      when(mockRepository.updateCartItem(tCartId, tProductId, tQuantity)).thenAnswer((_) async => tCart);

      // act
      final result = await usecase(tCartId, tProductId, tQuantity);

      // assert
      expect(result, equals(tCart));
      verify(mockRepository.updateCartItem(tCartId, tProductId, tQuantity));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
