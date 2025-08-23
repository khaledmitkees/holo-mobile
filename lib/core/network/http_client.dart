/// Abstract HTTP client interface for making network requests.
abstract class HttpClient {
  /// Performs a GET request to the specified [path].
  ///
  /// Optional [queryParameters] can be provided for URL parameters.
  /// Optional [headers] can be provided for request headers.
  ///
  /// Returns a [Future] that resolves to the response data of type [T].
  /// Throws [NetworkException] if the request fails.
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Performs a POST request to the specified [path].
  ///
  /// Optional [data] can be provided as the request body.
  /// Optional [queryParameters] can be provided for URL parameters.
  /// Optional [headers] can be provided for request headers.
  ///
  /// Returns a [Future] that resolves to the response data of type [T].
  /// Throws [NetworkException] if the request fails.
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Performs a PUT request to the specified [path].
  ///
  /// Optional [data] can be provided as the request body.
  /// Optional [queryParameters] can be provided for URL parameters.
  /// Optional [headers] can be provided for request headers.
  ///
  /// Returns a [Future] that resolves to the response data of type [T].
  /// Throws [NetworkException] if the request fails.
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Performs a DELETE request to the specified [path].
  ///
  /// Optional [queryParameters] can be provided for URL parameters.
  /// Optional [headers] can be provided for request headers.
  ///
  /// Returns a [Future] that resolves to the response data of type [T].
  /// Throws [NetworkException] if the request fails.
  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Performs a PATCH request to the specified [path].
  ///
  /// Optional [data] can be provided as the request body.
  /// Optional [queryParameters] can be provided for URL parameters.
  /// Optional [headers] can be provided for request headers.
  ///
  /// Returns a [Future] that resolves to the response data of type [T].
  /// Throws [NetworkException] if the request fails.
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}
