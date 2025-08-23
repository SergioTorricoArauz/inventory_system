// core/network/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'http://192.168.0.10:5214/api',
          headers: {'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

  Future<Response> post(String path, dynamic data) =>
      _dio.post(path, data: data);
  Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      _dio.get(path, queryParameters: query);
  Future<Response> put(String path, dynamic data) => _dio.put(path, data: data);
  Future<Response> delete(String path) => _dio.delete(path);
}
