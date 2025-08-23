import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_products.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts _getProducts;
  final LoggerInterface _logger;

  ProductsBloc({
    required GetProducts getProducts,
    required LoggerInterface logger,
  }) : _getProducts = getProducts,
       _logger = logger,
       super(const ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    try {
      final products = await _getProducts();
      emit(ProductsLoaded(products));
    } catch (error) {
      _logger.error('Failed to load products: $error');
      emit(ProductsError(error.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(const ProductsLoading());
      final products = await _getProducts();
      emit(ProductsLoaded(products));
    } catch (error) {
      _logger.error('Failed to refresh products: $error');
      emit(ProductsError(error.toString()));
    }
  }
}
