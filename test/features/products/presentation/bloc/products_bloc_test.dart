import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_products_use_case.dart';
import 'package:holo_mobile/features/products/presentation/bloc/products_bloc.dart';
import 'package:holo_mobile/features/products/presentation/bloc/products_event.dart';
import 'package:holo_mobile/features/products/presentation/bloc/products_state.dart';

import 'products_bloc_test.mocks.dart';

@GenerateMocks([GetProductsUseCase, LoggerInterface])
void main() {
  late ProductsBloc productsBloc;
  late MockGetProductsUseCase mockGetProducts;
  late MockLoggerInterface mockLogger;

  setUp(() {
    mockGetProducts = MockGetProductsUseCase();
    mockLogger = MockLoggerInterface();
    productsBloc = ProductsBloc(
      getProducts: mockGetProducts,
      logger: mockLogger,
    );
  });

  tearDown(() {
    productsBloc.close();
  });

  group('ProductsBloc', () {
    final tProduct1 = Product(
      id: 1,
      title: 'Test Product 1',
      price: 29.99,
      description: 'Test description 1',
      category: 'electronics',
      image: 'https://test.com/image1.jpg',
      rating: const Rating(rate: 4.5, count: 100),
    );

    final tProduct2 = Product(
      id: 2,
      title: 'Test Product 2',
      price: 49.99,
      description: 'Test description 2',
      category: 'clothing',
      image: 'https://test.com/image2.jpg',
      rating: const Rating(rate: 3.8, count: 50),
    );

    final tProductsList = [tProduct1, tProduct2];

    test('initial state should be ProductsInitial', () {
      expect(productsBloc.state, equals(const ProductsInitial()));
    });

    group('LoadProducts', () {
      blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsLoading, ProductsLoaded] when LoadProducts is added and getProducts succeeds',
        build: () {
          when(mockGetProducts()).thenAnswer((_) async => tProductsList);
          return productsBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const ProductsLoading(),
          ProductsLoaded(tProductsList),
        ],
        verify: (_) {
          verify(mockGetProducts()).called(1);
        },
      );

      blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsLoading, ProductsError] when LoadProducts is added and getProducts throws NetworkException',
        build: () {
          when(mockGetProducts()).thenThrow(
            const NetworkException(message: 'Network error'),
          );
          return productsBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const ProductsLoading(),
          const ProductsError('NetworkException: Network error (Status: null)'),
        ],
        verify: (_) {
          verify(mockGetProducts()).called(1);
          verify(mockLogger.error('Failed to load products: NetworkException: Network error (Status: null)')).called(1);
        },
      );

      blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsLoading, ProductsError] when LoadProducts is added and getProducts throws generic exception',
        build: () {
          when(mockGetProducts()).thenThrow(Exception('Generic error'));
          return productsBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const ProductsLoading(),
          const ProductsError('Exception: Generic error'),
        ],
        verify: (_) {
          verify(mockGetProducts()).called(1);
          verify(mockLogger.error('Failed to load products: Exception: Generic error')).called(1);
        },
      );
    });

    group('RefreshProducts', () {
      blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsLoading, ProductsLoaded] when RefreshProducts is added and getProducts succeeds',
        build: () {
          when(mockGetProducts()).thenAnswer((_) async => tProductsList);
          return productsBloc;
        },
        act: (bloc) => bloc.add(const RefreshProducts()),
        expect: () => [
          const ProductsLoading(),
          ProductsLoaded(tProductsList),
        ],
        verify: (_) {
          verify(mockGetProducts()).called(1);
        },
      );

      blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsLoading, ProductsError] when RefreshProducts is added and getProducts throws NetworkException',
        build: () {
          when(mockGetProducts()).thenThrow(
            const NetworkException(message: 'Network error'),
          );
          return productsBloc;
        },
        act: (bloc) => bloc.add(const RefreshProducts()),
        expect: () => [
          const ProductsLoading(),
          const ProductsError('NetworkException: Network error (Status: null)'),
        ],
        verify: (_) {
          verify(mockGetProducts()).called(1);
          verify(mockLogger.error('Failed to refresh products: NetworkException: Network error (Status: null)')).called(1);
        },
      );

      blocTest<ProductsBloc, ProductsState>(
        'emits [ProductsLoading, ProductsError] when RefreshProducts is added and getProducts throws generic exception',
        build: () {
          when(mockGetProducts()).thenThrow(Exception('Generic error'));
          return productsBloc;
        },
        act: (bloc) => bloc.add(const RefreshProducts()),
        expect: () => [
          const ProductsLoading(),
          const ProductsError('Exception: Generic error'),
        ],
        verify: (_) {
          verify(mockGetProducts()).called(1);
          verify(mockLogger.error('Failed to refresh products: Exception: Generic error')).called(1);
        },
      );
    });

    group('State transitions', () {
      blocTest<ProductsBloc, ProductsState>(
        'can handle multiple events in sequence',
        build: () {
          when(mockGetProducts()).thenAnswer((_) async => tProductsList);
          return productsBloc;
        },
        act: (bloc) {
          bloc.add(const LoadProducts());
          bloc.add(const RefreshProducts());
        },
        expect: () => [
          const ProductsLoading(),
          ProductsLoaded(tProductsList),
          const ProductsLoading(),
          ProductsLoaded(tProductsList),
        ],
        verify: (_) {
          verify(mockGetProducts()).called(2);
        },
      );

      blocTest<ProductsBloc, ProductsState>(
        'maintains loaded state after successful load until next event',
        build: () {
          when(mockGetProducts()).thenAnswer((_) async => tProductsList);
          return productsBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const ProductsLoading(),
          ProductsLoaded(tProductsList),
        ],
        verify: (_) {
          expect(productsBloc.state, isA<ProductsLoaded>());
          final loadedState = productsBloc.state as ProductsLoaded;
          expect(loadedState.products, equals(tProductsList));
        },
      );
    });
  });
}
