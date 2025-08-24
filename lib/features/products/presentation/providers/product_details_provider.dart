import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_mobile/core/di/service_locator.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/features/carts/domain/usecases/add_to_cart_use_case.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_product_use_case.dart';
import 'package:holo_mobile/features/products/presentation/bloc/product_details_bloc.dart';
import 'package:holo_mobile/features/products/presentation/bloc/product_details_event.dart';
import 'package:holo_mobile/features/products/presentation/pages/product_details_screen.dart';

class ProductDetailsProvider extends StatelessWidget {
  final int productId;

  const ProductDetailsProvider({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailsBloc>(
      create: (context) {
        final logger = getIt<LoggerInterface>();

        final getProductUseCase = GetProductUseCase(repository: getIt());
        final addToCartUseCase = AddToCartUseCase(repository: getIt());

        final bloc = ProductDetailsBloc(
          getProduct: getProductUseCase,
          addToCart: addToCartUseCase,
          logger: logger,
        );

        bloc.add(LoadProductDetails(productId));

        return bloc;
      },
      child: ProductDetailsScreen(productId: productId),
    );
  }
}
