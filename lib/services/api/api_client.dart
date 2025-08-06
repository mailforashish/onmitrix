import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:onmitrix/config/env_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;
  late final Logger _logger;
  late final EnvConfig _config;

  factory ApiClient() {
    return _instance;
  }

  void initialize(EnvConfig config) {
    _config = config;
    _logger = Logger();

    _dio = Dio(
      BaseOptions(
        baseUrl: _config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-Key': _config.apiKey,
        },
      ),
    );

    // Add interceptors for logging, error handling, etc.
    _dio.interceptors.addAll([
      _createAuthInterceptor(),
      _createLoggingInterceptor(),
    ]);
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get the token from your session manager
        final token = await _getAuthToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    );
  }

  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_config.enableLogging) {
          _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (_config.enableLogging) {
          _logger.i(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
        }
        return handler.next(response);
      },
      onError: (error, handler) {
        if (_config.enableLogging) {
          _logger.e(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
            error: error.error,
            stackTrace: StackTrace.current,
          );
        }
        return handler.next(error);
      },
    );
  }

  Future<String?> _getAuthToken() async {
    // TODO: Implement getting token from SessionManager
    return null;
  }

  ApiClient._internal();

  Dio get dio => _dio;
}