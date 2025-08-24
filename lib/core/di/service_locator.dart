import 'package:get_it/get_it.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/core/logging/app_logger.dart';
import 'package:holo_mobile/core/network/dio_client.dart';
import 'package:holo_mobile/core/network/http_client.dart';
import 'package:holo_mobile/features/carts/data/datasources/cart_local_data_source.dart';
import 'package:holo_mobile/core/storage/shared_preferences_interface.dart';
import 'package:holo_mobile/core/storage/shared_preferences_impl.dart';
import 'package:holo_mobile/features/products/data/datasources/products_remote_data_source.dart';
import 'package:holo_mobile/features/products/data/repositories/products_repository_impl.dart';
import 'package:holo_mobile/features/products/domain/repositories/products_repository.dart';
import 'package:holo_mobile/features/carts/data/datasources/carts_remote_data_source.dart';
import 'package:holo_mobile/features/carts/data/repositories/carts_repository_impl.dart';
import 'package:holo_mobile/features/carts/domain/repositories/carts_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  getIt.registerSingleton<LoggerInterface>(AppLogger());
  getIt.registerSingleton<HttpClient>(DioClient(logger: getIt<LoggerInterface>(), baseUrl: 'https://fakestoreapi.com'));
  getIt.registerLazySingleton<LocalStorageInterface>(() => LocalStorageImpl());
  getIt.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl(getIt()));

  // Data Sources
  getIt.registerLazySingleton<ProductsRemoteDataSource>(() => ProductsRemoteDataSourceImpl(
    httpClient: getIt<HttpClient>(),
    logger: getIt<LoggerInterface>(),
  ));
  getIt.registerLazySingleton<CartsRemoteDataSource>(() => CartsRemoteDataSourceImpl(
    httpClient: getIt<HttpClient>(),
  ));

  // Repositories
  getIt.registerLazySingleton<ProductsRepository>(() => ProductsRepositoryImpl(
    remoteDataSource: getIt<ProductsRemoteDataSource>(),
    logger: getIt<LoggerInterface>(),
  ));
  getIt.registerLazySingleton<CartsRepository>(() => CartsRepositoryImpl(
    remoteDataSource: getIt<CartsRemoteDataSource>(),
    cartLocalDataSource: getIt<CartLocalDataSource>(),
  ));

}
