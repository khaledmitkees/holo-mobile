import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:holo_mobile/core/logging/app_logger.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/core/network/dio_client.dart';
import 'package:holo_mobile/core/network/http_client.dart';

// Data sources
import 'package:holo_mobile/features/products/data/datasources/products_remote_data_source.dart';
import 'package:holo_mobile/features/carts/data/datasources/carts_remote_data_source.dart';

// Repositories
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';
import 'package:holo_mobile/features/products/data/repositories/products_repository_impl.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';
import 'package:holo_mobile/features/carts/data/repositories/carts_repository_impl.dart';

// Use cases
import 'package:holo_mobile/features/products/domain/usecases/get_all_products.dart';
import 'package:holo_mobile/features/products/domain/usecases/get_product.dart';
import 'package:holo_mobile/features/carts/domain/usecases/get_cart.dart';
import 'package:holo_mobile/features/carts/domain/usecases/create_cart.dart';
import 'package:holo_mobile/features/carts/domain/usecases/update_cart.dart';
import 'package:holo_mobile/features/carts/domain/usecases/delete_cart.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core dependencies
  getIt.registerSingleton<LoggerInterface>(AppLogger(isDebugMode: kDebugMode));
  getIt.registerSingleton<HttpClient>(
    DioClient(
      logger: getIt<LoggerInterface>(),
      baseUrl: 'https://fakestoreapi.com',
    ),
  );

  // Data sources
  getIt.registerSingleton<ProductsRemoteDataSource>(
    ProductsRemoteDataSourceImpl(httpClient: getIt<HttpClient>()),
  );
  getIt.registerSingleton<CartsRemoteDataSource>(
    CartsRemoteDataSourceImpl(httpClient: getIt<HttpClient>()),
  );

  // Repositories
  getIt.registerSingleton<ProductsRepository>(
    ProductsRepositoryImpl(remoteDataSource: getIt<ProductsRemoteDataSource>()),
  );
  getIt.registerSingleton<CartsRepository>(
    CartsRepositoryImpl(remoteDataSource: getIt<CartsRemoteDataSource>()),
  );

  // Use cases
  getIt.registerSingleton<GetAllProducts>(
    GetAllProducts(repository: getIt<ProductsRepository>()),
  );
  getIt.registerSingleton<GetProduct>(
    GetProduct(repository: getIt<ProductsRepository>()),
  );
  getIt.registerSingleton<GetCart>(
    GetCart(repository: getIt<CartsRepository>()),
  );
  getIt.registerSingleton<CreateCart>(
    CreateCart(repository: getIt<CartsRepository>()),
  );
  getIt.registerSingleton<UpdateCart>(
    UpdateCart(repository: getIt<CartsRepository>()),
  );
  getIt.registerSingleton<DeleteCart>(
    DeleteCart(repository: getIt<CartsRepository>()),
  );
}
