import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${AppConstants.baseUrl}${AppConstants.apiVersion}',
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add JWT token to headers
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
    handler.next(options);
  }

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.d(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    _logger.e(
      'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
    );

    // Handle 401 Unauthorized - try to refresh token
    if (error.response?.statusCode == 401) {
      try {
        final refreshToken = await _storage.read(
          key: AppConstants.keyRefreshToken,
        );
        
        if (refreshToken != null) {
          final response = await _dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          final newToken = response.data['token'];
          await _storage.write(
            key: AppConstants.keyAuthToken,
            value: newToken,
          );

          // Retry the original request
          final options = error.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await _dio.fetch(options);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        _logger.e('Token refresh failed: $e');
        // Clear tokens and redirect to login
        await _storage.deleteAll();
      }
    }

    handler.next(error);
  }

  Dio get dio => _dio;
}
