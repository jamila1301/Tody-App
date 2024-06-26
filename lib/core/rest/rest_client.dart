import 'dart:convert';

class ApiResponse {
  const ApiResponse({
    required this.statusCode,
    this.data,
  });

  final int statusCode;
  final dynamic data;
}

typedef HeaderBuilder = Future<Map<String, dynamic>?> Function();

abstract class RestClient {
  const RestClient({
    required this.baseUrl,
    this.headers,
  });

  final String? baseUrl;
  final HeaderBuilder? headers;

  Future<ApiResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<ApiResponse> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<ApiResponse> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<ApiResponse> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

  Uri buildUri(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    if (baseUrl != null) {
      final stringifiedQueries = queryParameters?.map(
        (key, value) {
          return MapEntry(key, value.toString());
        },
      );

      return Uri.http(baseUrl!, path, stringifiedQueries);
    }

    return Uri.parse(path);
  }

  dynamic decodeBody(String data) => jsonDecode(data);
}
