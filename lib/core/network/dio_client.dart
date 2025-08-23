import 'package:dio/dio.dart';
import 'package:holo_mobile/core/logging/logger_interface.dart';
import 'http_client.dart';
import 'network_exceptions.dart';

class DioClient implements HttpClient {
  late final Dio _dio;
  final LoggerInterface _logger;

  DioClient({
    required LoggerInterface logger,
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) : _logger = logger {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: connectTimeout ?? const Duration(seconds: 5),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 10),
        sendTimeout: sendTimeout ?? const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => _logger.network(object.toString()),
      ),
    );
  }

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  T _handleResponse<T>(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data as T;
    } else {
      throw NetworkException(
        message: 'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  NetworkException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutException();
        case DioExceptionType.connectionError:
          return const ConnectionException();
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            return const UnauthorizedException();
          } else if (statusCode == 404) {
            return const NotFoundException();
          } else {
            return ServerException(
              message: error.response?.statusMessage ?? 'Server error',
              statusCode: statusCode ?? 500,
            );
          }
        default:
          return NetworkException(message: error.message ?? 'Unknown error');
      }
    }
    return NetworkException(message: error.toString());
  }
}
