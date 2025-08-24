import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';
import 'package:holo_mobile/features/carts/domain/usecases/get_cart_use_case.dart';

import 'get_cart_test.mocks.dart';

@GenerateMocks([CartsRepository])
void main() {
  group('GetCartUseCase', () {
    late MockCartsRepository mockRepository;
    late GetCartUseCase usecase;

    setUp(() {
      mockRepository = MockCartsRepository();
      usecase = GetCartUseCase(repository: mockRepository);
    });

    test('should get cart from the repository', () async {
      // arrange
      const tCartId = 1;
      final tCart = Cart(
        id: 1,
        userId: 1,
        date: DateTime.parse('2020-03-02T00:00:00.000Z'),
        products: [
          const CartProduct(productId: 1, quantity: 4),
          const CartProduct(productId: 2, quantity: 1),
        ],
      );
      when(mockRepository.getCart(tCartId)).thenAnswer((_) async => tCart);

      // act
      final result = await usecase(tCartId);

      // assert
      expect(result, equals(tCart));
      verify(mockRepository.getCart(tCartId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
