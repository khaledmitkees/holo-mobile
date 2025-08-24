import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';
import 'package:holo_mobile/features/carts/domain/usecases/get_cart_use_case.dart';
import 'package:holo_mobile/features/carts/domain/usecases/update_cart_use_case.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_product_use_case.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_bloc.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_event.dart';
import 'package:holo_mobile/features/carts/presentation/pages/cart_screen.dart';

final getIt = GetIt.instance;

class CartProvider extends StatelessWidget {
  const CartProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (context) {
        final logger = getIt<LoggerInterface>();
        final cartsRepository = getIt<CartsRepository>();
        final productsRepository = getIt<ProductsRepository>();
        final getCartUseCase = GetCartUseCase(repository: cartsRepository);
        final updateCartUseCase = UpdateCartUseCase(repository: cartsRepository);
        final getProductUseCase = GetProductUseCase(repository: productsRepository);

        final bloc = CartBloc(
          getCart: getCartUseCase,
          updateCart: updateCartUseCase,
          getProduct: getProductUseCase,
          logger: logger,
        );

        bloc.add(const LoadCart());
        return bloc;
      },
      child: const CartScreen(),
    );
  }
}
