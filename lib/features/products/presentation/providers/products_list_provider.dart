import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_products_use_case.dart';
import 'package:holo_mobile/features/products/presentation/bloc/products_bloc.dart';
import 'package:holo_mobile/features/products/presentation/bloc/products_event.dart';
import 'package:holo_mobile/features/products/presentation/pages/products_screen.dart';

final getIt = GetIt.instance;

class ProductsListProvider extends StatelessWidget {
  const ProductsListProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductsBloc>(
      create: (context) {
        final logger = getIt<LoggerInterface>();
        final productsRepository = getIt<ProductsRepository>();
        final getProductsUseCase = GetProductsUseCase(productsRepository);

        final bloc = ProductsBloc(
          getProducts: getProductsUseCase,
          logger: logger,
        );

        bloc.add(const LoadProducts());
        return bloc;
      },
      child: const ProductsScreen(),
    );
  }
}
