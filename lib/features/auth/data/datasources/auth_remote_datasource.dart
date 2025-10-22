import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/auth_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? school,
    String? branch,
  });
  Future<void> logout();
  Future<AuthResponse> getCurrentUser();
  Future<AuthResponse> refreshToken(String refreshToken);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final AppLogger _logger;

  AuthRemoteDataSourceImpl(this._apiClient, this._logger);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        AppConstants.loginEndpoint,
        data: {
          'eposta': email,
          'sifre': password,
        },
      );

      if (response.statusCode == 200) {
        // Parse Turkish API response
        final apiResponse = LoginApiResponse.fromJson(response.data);

        // Check if login was successful
        if (!apiResponse.basarili) {
          throw AuthException('Login failed');
        }

        // Convert to AuthResponse
        return apiResponse.toAuthResponse();
      } else {
        throw AuthException('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Invalid email or password');
      } else if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        final errorMessage = errors?.values.first?.first ?? 'Validation failed';
        throw AuthException(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection available.');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      if (e is AuthException || e is NetworkException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? school,
    String? branch,
  }) async {
    try {
      final data = {
        'email': email,
        'password': password,
        'name': name,
      };

      if (phone != null) data['phone'] = phone;
      if (school != null) data['school'] = school;
      if (branch != null) data['branch'] = branch;

      final response = await _apiClient.post(
        AppConstants.registerEndpoint,
        data: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw AuthException('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        final errorMessage = errors?.values.first?.first ?? 'Validation failed';
        throw AuthException(errorMessage);
      } else if (e.response?.statusCode == 409) {
        throw AuthException('An account with this email already exists');
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection available.');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      if (e is AuthException || e is NetworkException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(AppConstants.logoutEndpoint);
    } on DioException catch (e) {
      // Don't throw error for logout, just log it
      // The user should still be logged out locally even if server logout fails
      _logger.logAuthError('logout_failed', e);
    } catch (e) {
      _logger.logAuthError('unexpected_logout_error', e);
    }
  }

  @override
  Future<AuthResponse> getCurrentUser() async {
    try {
      final response = await _apiClient.get(AppConstants.userEndpoint);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw AuthException('Failed to get user data: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Authentication token expired');
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection available.');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      if (e is AuthException || e is NetworkException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        AppConstants.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw AuthException('Token refresh failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException('Refresh token expired or invalid');
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection available.');
      } else {
        throw ServerException('Server error: ${e.message}');
      }
    } catch (e) {
      if (e is AuthException || e is NetworkException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error occurred: $e');
    }
  }
}