import 'package:flutter_test/flutter_test.dart';
import 'package:holo_mobile/core/network/network_exceptions.dart';

void main() {
  group('NetworkException', () {
    test('should create with message', () {
      const exception = NetworkException(message: 'Test error');
      expect(exception.message, equals('Test error'));
      expect(exception.toString(), contains('Test error'));
    });

    test('should have default message', () {
      const exception = NetworkException(message: 'Network error occurred');
      expect(exception.message, equals('Network error occurred'));
    });
  });

  group('ServerException', () {
    test('should create with message and status code', () {
      const exception = ServerException(
        message: 'Server error',
        statusCode: 500,
      );
      expect(exception.message, equals('Server error'));
      expect(exception.statusCode, equals(500));
    });

    test('should extend NetworkException', () {
      const exception = ServerException(message: 'Test', statusCode: 400);
      expect(exception, isA<NetworkException>());
    });
  });

  group('TimeoutException', () {
    test('should have correct message', () {
      const exception = TimeoutException();
      expect(exception.message, equals('Request timeout'));
    });

    test('should extend NetworkException', () {
      const exception = TimeoutException();
      expect(exception, isA<NetworkException>());
    });
  });

  group('ConnectionException', () {
    test('should have correct message', () {
      const exception = ConnectionException();
      expect(exception.message, equals('No internet connection'));
    });

    test('should extend NetworkException', () {
      const exception = ConnectionException();
      expect(exception, isA<NetworkException>());
    });
  });

  group('UnauthorizedException', () {
    test('should extend NetworkException', () {
      const exception = UnauthorizedException();
      expect(exception, isA<NetworkException>());
    });
  });

  group('NotFoundException', () {
    test('should have correct message', () {
      const exception = NotFoundException();
      expect(exception.message, equals('Resource not found'));
    });

    test('should extend NetworkException', () {
      const exception = NotFoundException();
      expect(exception, isA<NetworkException>());
    });
  });
}
