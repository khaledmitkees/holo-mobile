import 'package:flutter_test/flutter_test.dart';
import 'package:holo_mobile/core/logging/app_logger.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';

void main() {
  group('AppLogger', () {
    late LoggerInterface logger;

    setUp(() {
      logger = AppLogger(isDebugMode: true);
    });

    test('should implement LoggerInterface', () {
      expect(logger, isA<LoggerInterface>());
    });

    test('should create logger with debug mode enabled', () {
      final debugLogger = AppLogger(isDebugMode: true);
      expect(debugLogger, isA<AppLogger>());
    });

    test('should create logger with debug mode disabled', () {
      final productionLogger = AppLogger(isDebugMode: false);
      expect(productionLogger, isA<AppLogger>());
    });

    test('should have all required logging methods', () {
      expect(() => logger.debug('test message'), returnsNormally);
      expect(() => logger.info('test message'), returnsNormally);
      expect(() => logger.warning('test message'), returnsNormally);
      expect(() => logger.error('test message'), returnsNormally);
      expect(() => logger.fatal('test message'), returnsNormally);
      expect(() => logger.network('test message'), returnsNormally);
    });

    test('should handle optional parameters in logging methods', () {
      final error = Exception('test error');
      final stackTrace = StackTrace.current;

      expect(() => logger.debug('test', error, stackTrace), returnsNormally);
      expect(() => logger.info('test', error, stackTrace), returnsNormally);
      expect(() => logger.warning('test', error, stackTrace), returnsNormally);
      expect(() => logger.error('test', error, stackTrace), returnsNormally);
      expect(() => logger.fatal('test', error, stackTrace), returnsNormally);
    });

    test('should handle null optional parameters', () {
      expect(() => logger.debug('test', null, null), returnsNormally);
      expect(() => logger.info('test', null, null), returnsNormally);
      expect(() => logger.warning('test', null, null), returnsNormally);
      expect(() => logger.error('test', null, null), returnsNormally);
      expect(() => logger.fatal('test', null, null), returnsNormally);
    });
  });
}
