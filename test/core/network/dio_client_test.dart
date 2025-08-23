import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:holo_mobile/core/network/dio_client.dart';
import 'package:holo_mobile/core/network/http_client.dart';
import 'package:holo_mobile/core/network/network_exceptions.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';

import 'dio_client_test.mocks.dart';

@GenerateMocks([LoggerInterface])
void main() {
  group('DioClient', () {
    late MockLoggerInterface mockLogger;
    late DioClient dioClient;

    setUp(() {
      mockLogger = MockLoggerInterface();
      dioClient = DioClient(logger: mockLogger);
    });

    test('should implement HttpClient interface', () {
      expect(dioClient, isA<HttpClient>());
    });

    test('should initialize with default configuration', () {
      expect(dioClient, isNotNull);
      expect(dioClient.dio, isA<Dio>());
    });

    test('should initialize with custom configuration', () {
      final customClient = DioClient(
        logger: mockLogger,
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 45),
      );

      expect(customClient, isNotNull);
      expect(
        customClient.dio.options.baseUrl,
        equals('https://api.example.com'),
      );
      expect(
        customClient.dio.options.connectTimeout,
        equals(const Duration(seconds: 30)),
      );
      expect(
        customClient.dio.options.receiveTimeout,
        equals(const Duration(seconds: 60)),
      );
      expect(
        customClient.dio.options.sendTimeout,
        equals(const Duration(seconds: 45)),
      );
    });

    test('should have correct default headers', () {
      final headers = dioClient.dio.options.headers;
      expect(headers['Content-Type'], equals('application/json'));
      expect(headers['Accept'], equals('application/json'));
    });

    group('Error Handling', () {
      test('should throw TimeoutException for connection timeout', () async {
        final client = DioClient(
          logger: mockLogger,
          baseUrl: 'https://httpbin.org',
          connectTimeout: const Duration(seconds: 1),
          receiveTimeout: const Duration(seconds: 1),
        );

        expect(() => client.get('/delay/10'), throwsA(isA<TimeoutException>()));
      });

      test('should throw ConnectionException for connection error', () async {
        final client = DioClient(
          logger: mockLogger,
          baseUrl: 'http://0.0.0.0:1',
          connectTimeout: const Duration(seconds: 1),
        );

        await expectLater(
          () => client.get('/test'),
          throwsA(isA<ConnectionException>()),
        );
      });
    });

    group('HTTP Methods', () {
      test('should have get method', () {
        expect(dioClient.get, isA<Function>());
      });

      test('should have post method', () {
        expect(dioClient.post, isA<Function>());
      });

      test('should have put method', () {
        expect(dioClient.put, isA<Function>());
      });

      test('should have delete method', () {
        expect(dioClient.delete, isA<Function>());
      });

      test('should have patch method', () {
        expect(dioClient.patch, isA<Function>());
      });
    });
  });
}
