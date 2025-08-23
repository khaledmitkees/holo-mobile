import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:holo_mobile/core/logging/app_logger.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/core/network/dio_client.dart';
import 'package:holo_mobile/core/network/http_client.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register logger
  getIt.registerSingleton<LoggerInterface>(AppLogger(isDebugMode: kDebugMode));

  // Register HTTP client with base URL
  getIt.registerSingleton<HttpClient>(
    DioClient(
      logger: getIt<LoggerInterface>(),
      baseUrl: 'https://fakestoreapi.com',
    ),
  );
}
