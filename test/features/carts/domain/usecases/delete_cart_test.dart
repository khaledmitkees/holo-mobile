import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';
import 'package:holo_mobile/features/carts/domain/usecases/delete_cart.dart';

import 'delete_cart_test.mocks.dart';

@GenerateMocks([CartsRepository])
void main() {
  group('DeleteCart', () {
    late MockCartsRepository mockRepository;
    late DeleteCart usecase;

    setUp(() {
      mockRepository = MockCartsRepository();
      usecase = DeleteCart(repository: mockRepository);
    });

    test('should delete cart via the repository', () async {
      // arrange
      const tCartId = 1;
      when(mockRepository.deleteCart(tCartId)).thenAnswer((_) async {});

      // act
      await usecase(tCartId);

      // assert
      verify(mockRepository.deleteCart(tCartId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
