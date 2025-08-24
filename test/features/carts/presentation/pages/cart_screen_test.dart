import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_bloc.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_state.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_event.dart';
import 'package:holo_mobile/features/carts/presentation/pages/cart_screen.dart';

import 'cart_screen_test.mocks.dart';

@GenerateMocks([CartBloc])
void main() {
  late MockCartBloc mockCartBloc;

  setUp(() {
    mockCartBloc = MockCartBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<CartBloc>.value(
        value: mockCartBloc,
        child: const CartScreen(),
      ),
    );
  }

  group('CartScreen', () {
    final tCart = Cart(
      id: 1,
      userId: 1,
      date: DateTime.now(),
      products: [
        const CartProduct(productId: 1, quantity: 2),
        const CartProduct(productId: 2, quantity: 1),
      ],
    );

    final tProducts = [
      Product(
        id: 1,
        title: 'Product 1',
        price: 10.0,
        description: 'Description 1',
        category: 'Category 1',
        image: 'image1.jpg',
        rating: const Rating(rate: 4.5, count: 100),
      ),
      Product(
        id: 2,
        title: 'Product 2',
        price: 20.0,
        description: 'Description 2',
        category: 'Category 2',
        image: 'image2.jpg',
        rating: const Rating(rate: 4.0, count: 50),
      ),
    ];

    testWidgets('displays loading indicator when CartLoading', (tester) async {
      when(mockCartBloc.state).thenReturn(const CartLoading());
      when(mockCartBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty cart message when CartEmpty', (tester) async {
      when(mockCartBloc.state).thenReturn(const CartEmpty());
      when(mockCartBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Your Cart is Empty'), findsOneWidget);
      expect(find.text('Add some products to get started'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('displays cart items when CartLoaded', (tester) async {
      final cartLoaded = CartLoaded(
        cart: tCart,
        products: tProducts,
        total: 40.0,
        isUpdating: false,
      );

      when(mockCartBloc.state).thenReturn(cartLoaded);
      when(mockCartBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
      expect(find.text('\$20.00'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('\$40.00'), findsOneWidget);
    });

    testWidgets('displays error message when CartError', (tester) async {
      when(mockCartBloc.state).thenReturn(const CartError('Something went wrong'));
      when(mockCartBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Error Loading Cart'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('calls UpdateCartItemQuantity when quantity is increased', (tester) async {
      final cartLoaded = CartLoaded(
        cart: tCart,
        products: tProducts,
        total: 40.0,
        isUpdating: false,
      );

      when(mockCartBloc.state).thenReturn(cartLoaded);
      when(mockCartBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      // Find the first increase button (+ button)
      final increaseButtons = find.byIcon(Icons.add);
      expect(increaseButtons, findsAtLeastNWidgets(1));

      await tester.tap(increaseButtons.first);
      await tester.pump();

      verify(mockCartBloc.add(const UpdateCartItemQuantity(productId: 1, quantity: 3))).called(1);
    });

    testWidgets('calls UpdateCartItemQuantity when quantity is decreased', (tester) async {
      final cartLoaded = CartLoaded(
        cart: tCart,
        products: tProducts,
        total: 40.0,
        isUpdating: false,
      );

      when(mockCartBloc.state).thenReturn(cartLoaded);
      when(mockCartBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      // Find the first decrease button (- button)
      final decreaseButtons = find.byIcon(Icons.remove);
      expect(decreaseButtons, findsAtLeastNWidgets(1));

      await tester.tap(decreaseButtons.first);
      await tester.pump();

      verify(mockCartBloc.add(const UpdateCartItemQuantity(productId: 1, quantity: 1))).called(1);
    });

    // Remove button test removed since X button was removed from UI

    testWidgets('calls ClearCart when clear cart button is tapped', (tester) async {
      final cartLoaded = CartLoaded(
        cart: tCart,
        products: tProducts,
        total: 40.0,
        isUpdating: false,
      );

      when(mockCartBloc.state).thenReturn(cartLoaded);
      when(mockCartBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap the clear cart button
      final clearCartButton = find.text('Clear Cart');
      expect(clearCartButton, findsOneWidget);

      await tester.tap(clearCartButton);
      await tester.pump();

      verify(mockCartBloc.add(const ClearCart())).called(1);
    });

    testWidgets('displays loading overlay when isUpdating is true', (tester) async {
      final cartLoaded = CartLoaded(
        cart: tCart,
        products: tProducts,
        total: 40.0,
        isUpdating: true,
      );

      when(mockCartBloc.state).thenReturn(cartLoaded);
      when(mockCartBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      // Should find the loading overlay
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });
  });
}
