import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';
import '../data/local/token_stroge.dart' as token_storage;
import '../errors/exceptions.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;

  ApiClient(this._dio, this._logger) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: AppConstants.connectTimeout);
    _dio.options.receiveTimeout = const Duration(milliseconds: AppConstants.receiveTimeout);

    // Add connectivity interceptor (checks internet connection)
    _dio.interceptors.add(ConnectivityInterceptor());

    // Add retry interceptor (retries failed requests)
    _dio.interceptors.add(RetryInterceptor(maxRetries: 3));

    // Request interceptor (token and logging)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token
          final token = await token_storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          _logger.d('Headers: ${options.headers}');
          _logger.d('Request data: ${options.data}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) async {
          _logger.e('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          _logger.e('Error message: ${error.message}');
          _logger.e('Response body: ${error.response?.data}');
          
          // Handle token refresh on 401
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the request
              final options = error.requestOptions;
              final token = await token_storage.getToken();
              options.headers['Authorization'] = 'Bearer $token';

              try {
                final response = await _dio.fetch(options);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    // Token refresh not implemented with SharedPreferences
    return false;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        
        if (statusCode == 401) {
          return const AuthException('Unauthorized');
        } else if (statusCode == 403) {
          return const AuthException('Forbidden');
        } else if (statusCode! >= 500) {
          return ServerException(message, statusCode: statusCode);
        } else {
          return ServerException(message, statusCode: statusCode);
        }
      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');
      default:
        return const NetworkException('Unknown network error');
    }
  }
}