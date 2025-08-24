import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/carts/domain/usecases/get_cart_use_case.dart';
import 'package:holo_mobile/features/carts/domain/usecases/update_cart_use_case.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_product_use_case.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_bloc.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_event.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_state.dart';

import 'cart_bloc_test.mocks.dart';

@GenerateMocks([
  GetCartUseCase,
  UpdateCartUseCase,
  GetProductUseCase,
  LoggerInterface,
])
void main() {
  late CartBloc cartBloc;
  late MockGetCartUseCase mockGetCart;
  late MockUpdateCartUseCase mockUpdateCart;
  late MockGetProductUseCase mockGetProduct;
  late MockLoggerInterface mockLogger;

  setUp(() {
    mockGetCart = MockGetCartUseCase();
    mockUpdateCart = MockUpdateCartUseCase();
    mockGetProduct = MockGetProductUseCase();
    mockLogger = MockLoggerInterface();

    cartBloc = CartBloc(
      getCart: mockGetCart,
      updateCart: mockUpdateCart,
      getProduct: mockGetProduct,
      logger: mockLogger,
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc', () {
    final tCart = Cart(
      id: 1,
      userId: 1,
      date: DateTime.now(),
      products: [
        const CartProduct(productId: 1, quantity: 2),
        const CartProduct(productId: 2, quantity: 1),
      ],
    );

    final tProduct1 = Product(
      id: 1,
      title: 'Product 1',
      price: 10.0,
      description: 'Description 1',
      category: 'Category 1',
      image: 'image1.jpg',
      rating: const Rating(rate: 4.5, count: 100),
    );

    final tProduct2 = Product(
      id: 2,
      title: 'Product 2',
      price: 20.0,
      description: 'Description 2',
      category: 'Category 2',
      image: 'image2.jpg',
      rating: const Rating(rate: 4.0, count: 50),
    );

    test('initial state should be CartInitial', () {
      expect(cartBloc.state, const CartInitial());
    });

    group('LoadCart', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartLoaded] when cart is loaded successfully',
        build: () {
          when(mockGetCart.call(any)).thenAnswer((_) async => tCart);
          when(mockGetProduct.call(1)).thenAnswer((_) async => tProduct1);
          when(mockGetProduct.call(2)).thenAnswer((_) async => tProduct2);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [
          const CartLoading(),
          CartLoaded(
            cart: tCart,
            products: [tProduct1, tProduct2],
            total: 40.0, // (10.0 * 2) + (20.0 * 1)
            isUpdating: false,
          ),
        ],
        verify: (_) {
          verify(mockGetCart.call(1)).called(1);
          verify(mockGetProduct.call(1)).called(1);
          verify(mockGetProduct.call(2)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartEmpty] when cart is empty',
        build: () {
          final emptyCart = Cart(
            id: 1,
            userId: 1,
            date: DateTime.now(),
            products: [],
          );
          when(mockGetCart.call(any)).thenAnswer((_) async => emptyCart);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [
          const CartLoading(),
          const CartEmpty(),
        ],
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartError] when loading fails',
        build: () {
          when(mockGetCart.call(any)).thenThrow(Exception('Failed to load cart'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [
          const CartLoading(),
          const CartError('Exception: Failed to load cart'),
        ],
        verify: (_) {
          verify(mockLogger.error('Failed to load cart: Exception: Failed to load cart')).called(1);
        },
      );
    });

    group('UpdateCartItemQuantity', () {
      blocTest<CartBloc, CartState>(
        'updates cart item quantity successfully',
        build: () {
          when(mockUpdateCart.call(any, any, any)).thenAnswer((_) async => tCart);
          return cartBloc;
        },
        seed: () => CartLoaded(
          cart: tCart,
          products: [tProduct1, tProduct2],
          total: 40.0,
          isUpdating: false,
        ),
        act: (bloc) => bloc.add(const UpdateCartItemQuantity(productId: 1, quantity: 3)),
        expect: () => [
          CartLoaded(
            cart: tCart,
            products: [tProduct1, tProduct2],
            total: 40.0,
            isUpdating: true,
          ),
          CartLoaded(
            cart: Cart(
              id: 1,
              userId: 1,
              date: tCart.date,
              products: [
                const CartProduct(productId: 1, quantity: 3),
                const CartProduct(productId: 2, quantity: 1),
              ],
            ),
            products: [tProduct1, tProduct2],
            total: 50.0, // (10.0 * 3) + (20.0 * 1)
            isUpdating: false,
          ),
        ],
        verify: (_) {
          verify(mockUpdateCart.call(1, 1, 3)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits error when update fails',
        build: () {
          when(mockUpdateCart.call(any, any, any)).thenThrow(Exception('Update failed'));
          return cartBloc;
        },
        seed: () => CartLoaded(
          cart: tCart,
          products: [tProduct1, tProduct2],
          total: 40.0,
          isUpdating: false,
        ),
        act: (bloc) => bloc.add(const UpdateCartItemQuantity(productId: 1, quantity: 3)),
        expect: () => [
          CartLoaded(
            cart: tCart,
            products: [tProduct1, tProduct2],
            total: 40.0,
            isUpdating: true,
          ),
          CartLoaded(
            cart: tCart,
            products: [tProduct1, tProduct2],
            total: 40.0,
            isUpdating: false,
            errorMessage: 'Failed to update cart item',
          ),
        ],
      );

      blocTest<CartBloc, CartState>(
        'removes item when quantity is 0',
        build: () {
          final emptyCart = Cart(
            id: 1,
            userId: 1,
            date: tCart.date,
            products: [const CartProduct(productId: 2, quantity: 1)],
          );
          when(mockUpdateCart.call(any, any, any)).thenAnswer((_) async => emptyCart);
          return cartBloc;
        },
        seed: () => CartLoaded(
          cart: tCart,
          products: [tProduct1, tProduct2],
          total: 40.0,
          isUpdating: false,
        ),
        act: (bloc) => bloc.add(const UpdateCartItemQuantity(productId: 1, quantity: 0)),
        expect: () => [
          CartLoaded(
            cart: tCart,
            products: [tProduct1, tProduct2],
            total: 40.0,
            isUpdating: true,
          ),
          CartLoaded(
            cart: Cart(
              id: 1,
              userId: 1,
              date: tCart.date,
              products: [const CartProduct(productId: 2, quantity: 1)],
            ),
            products: [tProduct2],
            total: 20.0,
            isUpdating: false,
          ),
        ],
        verify: (_) {
          verify(mockUpdateCart.call(1, 1, 0)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'shows empty state when all items removed',
        build: () {
          final emptyCart = Cart(
            id: 1,
            userId: 1,
            date: tCart.date,
            products: [],
          );
          when(mockUpdateCart.call(any, any, any)).thenAnswer((_) async => emptyCart);
          return cartBloc;
        },
        seed: () => CartLoaded(
          cart: Cart(
            id: 1,
            userId: 1,
            date: tCart.date,
            products: [const CartProduct(productId: 1, quantity: 1)],
          ),
          products: [tProduct1],
          total: 10.0,
          isUpdating: false,
        ),
        act: (bloc) => bloc.add(const UpdateCartItemQuantity(productId: 1, quantity: 0)),
        expect: () => [
          CartLoaded(
            cart: Cart(
              id: 1,
              userId: 1,
              date: tCart.date,
              products: [const CartProduct(productId: 1, quantity: 1)],
            ),
            products: [tProduct1],
            total: 10.0,
            isUpdating: true,
          ),
          const CartEmpty(),
        ],
        verify: (_) {
          verify(mockUpdateCart.call(1, 1, 0)).called(1);
        },
      );
    });

    group('RemoveCartItem', () {
      blocTest<CartBloc, CartState>(
        'removes cart item successfully',
        build: () {
          when(mockUpdateCart.call(any, any, any)).thenAnswer((_) async => tCart);
          return cartBloc;
        },
        seed: () => CartLoaded(
          cart: tCart,
          products: [tProduct1, tProduct2],
          total: 40.0,
          isUpdating: false,
        ),
        act: (bloc) => bloc.add(const RemoveCartItem(1)),
        expect: () => [
          CartLoaded(
            cart: tCart,
            products: [tProduct1, tProduct2],
            total: 40.0,
            isUpdating: true,
          ),
          CartLoaded(
            cart: Cart(
              id: 1,
              userId: 1,
              date: tCart.date,
              products: [
                const CartProduct(productId: 2, quantity: 1),
              ],
            ),
            products: [tProduct2],
            total: 20.0, // Only product 2 remains
            isUpdating: false,
          ),
        ],
        verify: (_) {
          verify(mockUpdateCart.call(1, 1, 0)).called(1);
        },
      );
    });

    group('ClearCart', () {
      blocTest<CartBloc, CartState>(
        'clears cart successfully',
        build: () {
          when(mockUpdateCart.call(any, any, any)).thenAnswer((_) async => tCart);
          return cartBloc;
        },
        seed: () => CartLoaded(
          cart: tCart,
          products: [tProduct1, tProduct2],
          total: 40.0,
          isUpdating: false,
        ),
        act: (bloc) => bloc.add(const ClearCart()),
        expect: () => [
          CartLoaded(
            cart: tCart,
            products: [tProduct1, tProduct2],
            total: 40.0,
            isUpdating: true,
          ),
          const CartEmpty(),
        ],
        verify: (_) {
          verify(mockUpdateCart.call(1, 1, 0)).called(1);
          verify(mockUpdateCart.call(1, 2, 0)).called(1);
        },
      );
    });
  });
}
