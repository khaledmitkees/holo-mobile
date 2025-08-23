import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/network/http_client.dart';
import '../../../../core/logging/logger_interface.dart';
import '../../domain/usecases/get_products.dart';
import '../../data/datasources/products_remote_data_source.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../pages/products_screen.dart';

final getIt = GetIt.instance;

class ProductsListProvider extends StatelessWidget {
  const ProductsListProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductsBloc>(
      create: (context) {
        // Get core dependencies from service locator
        final httpClient = getIt<HttpClient>();
        final logger = getIt<LoggerInterface>();

        // Create data source
        final productsRemoteDataSource = ProductsRemoteDataSourceImpl(
          httpClient: httpClient,
          logger: logger,
        );

        final productsRepository = ProductsRepositoryImpl(
          remoteDataSource: productsRemoteDataSource,
          logger: logger,
        );

        // Create use case
        final getProducts = GetProducts(productsRepository);

        final bloc = ProductsBloc(getProducts: getProducts, logger: logger);

        // Trigger initial load
        bloc.add(const LoadProducts());

        return bloc;
      },
      child: const ProductsScreen(),
    );
  }
}
