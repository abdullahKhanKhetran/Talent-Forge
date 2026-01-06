import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

/// Configured Dio HTTP Client for TalentForge.
/// Points to the .NET Gateway exclusively.
class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  DioClient({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${ApiConstants.baseUrl}${ApiConstants.apiVersion}',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add JWT token from secure storage
          final token = await _secureStorage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          // Handle 401 - Token expired
          if (e.response?.statusCode == 401) {
            // TODO: Implement token refresh logic
            // await _refreshToken();
            // Retry request
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return _dio.get(path, queryParameters: queryParams);
  }

  /// POST request
  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  /// PUT request
  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  /// DELETE request
  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }

  /// Save tokens to secure storage
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    if (refreshToken != null) {
      await _secureStorage.write(key: 'refresh_token', value: refreshToken);
    }
  }

  /// Clear tokens from secure storage
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }
}
