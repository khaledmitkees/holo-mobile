import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_product_use_case.dart';
import 'package:holo_mobile/features/carts/domain/usecases/add_to_cart_use_case.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductUseCase _getProduct;
  final AddToCartUseCase _addToCart;
  final LoggerInterface _logger;

  ProductDetailsBloc({
    required GetProductUseCase getProduct,
    required AddToCartUseCase addToCart,
    required LoggerInterface logger,
  }) : _getProduct = getProduct,
       _addToCart = addToCart,
       _logger = logger,
       super(const ProductDetailsInitial()) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<AddProductToCart>(_onAddProductToCart);
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(const ProductDetailsLoading());

    try {
      final product = await _getProduct(event.productId);
      emit(ProductDetailsLoaded(product: product));
    } catch (error) {
      _logger.error('Failed to load product details: $error');
      emit(ProductDetailsError(error.toString()));
    }
  }

  Future<void> _onAddProductToCart(
    AddProductToCart event,
    Emitter<ProductDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductDetailsLoaded) return;

    emit(ProductDetailsLoaded(product: currentState.product, isLoading: true));
    try {
      await _addToCart(event.productId, event.quantity);
      emit(ProductAddedToCart(currentState.product));

      emit(
        ProductDetailsLoaded(product: currentState.product, isLoading: false),
      );
    } catch (error) {
      _logger.error('Failed to add product to cart: $error');
      emit(
        AddToCartError(
          message: error.toString(),
          product: currentState.product,
        ),
      );

      emit(ProductDetailsLoaded(product: currentState.product));
    }
  }
}
