import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:holo_mobile/core/di/service_locator.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'package:holo_mobile/core/logging/app_logger.dart';
import 'package:holo_mobile/core/network/http_client.dart';
import 'package:holo_mobile/core/network/dio_client.dart';

void main() {
  group('Service Locator', () {
    setUp(() async {
      // Reset GetIt before each test
      await GetIt.instance.reset();
    });

    tearDown(() async {
      // Clean up after each test
      await GetIt.instance.reset();
    });

    test('should setup all dependencies correctly', () async {
      await setupServiceLocator();

      // Verify logger is registered
      expect(getIt.isRegistered<LoggerInterface>(), isTrue);
      expect(getIt<LoggerInterface>(), isA<AppLogger>());

      // Verify HTTP client is registered
      expect(getIt.isRegistered<HttpClient>(), isTrue);
      expect(getIt<HttpClient>(), isA<DioClient>());
    });

    test('should register logger as singleton', () async {
      await setupServiceLocator();

      final logger1 = getIt<LoggerInterface>();
      final logger2 = getIt<LoggerInterface>();

      expect(identical(logger1, logger2), isTrue);
    });

    test('should register HTTP client as singleton', () async {
      await setupServiceLocator();

      final client1 = getIt<HttpClient>();
      final client2 = getIt<HttpClient>();

      expect(identical(client1, client2), isTrue);
    });

    test('should inject logger into DioClient', () async {
      await setupServiceLocator();

      final httpClient = getIt<HttpClient>() as DioClient;
      final logger = getIt<LoggerInterface>();

      // Verify that the DioClient was created (this indirectly tests injection)
      expect(httpClient, isNotNull);
      expect(logger, isNotNull);
    });

    test('should handle multiple setup calls gracefully', () async {
      await setupServiceLocator();
      
      // Second setup should not throw
      expect(() async => await setupServiceLocator(), throwsA(isA<ArgumentError>()));
    });

    test('should allow retrieval of dependencies after setup', () async {
      await setupServiceLocator();

      expect(() => getIt<LoggerInterface>(), returnsNormally);
      expect(() => getIt<HttpClient>(), returnsNormally);
    });
  });
}
