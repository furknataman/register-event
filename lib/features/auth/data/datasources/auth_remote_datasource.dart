import 'package:dio/dio.dart';

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
  Future<void> sendPasswordResetCode({
    required String emailOrPhone,
    required int type, // 1: email, 2: sms
  });
  Future<void> resetPassword({
    required int code,
    required int type,
    required String emailOrPhone,
    required String password,
    required String passwordConfirm,
  });
}

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
    // No server-side logout endpoint available
    // Token cleanup is handled in the repository layer
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

  @override
  Future<void> sendPasswordResetCode({
    required String emailOrPhone,
    required int type,
  }) async {
    try {
      _logger.info('Sending password reset code to $emailOrPhone via type $type');

      final response = await _apiClient.post(
        AppConstants.forgotPasswordEndpoint,
        data: {
          'eposta': type == 1 ? emailOrPhone : '',
          'telefon': type == 2 ? emailOrPhone : '',
          'tur': type,
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ForgotPasswordResponse.fromJson(response.data);

        if (!apiResponse.basarili) {
          // Backend sometimes returns basarili: false but message says "gönderildi" (sent)
          // Check if message indicates success
          final mesaj = apiResponse.mesaj?.toLowerCase() ?? '';
          if (!mesaj.contains('gönderildi') && !mesaj.contains('sent')) {
            throw AuthException(apiResponse.mesaj ?? 'Failed to send reset code');
          }
        }

        _logger.info('Password reset code sent successfully');
      } else {
        throw AuthException('Failed to send reset code: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _logger.error('Error sending password reset code: ${e.message}');

      if (e.response?.statusCode == 404) {
        throw AuthException('Email or phone not found');
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
  Future<void> resetPassword({
    required int code,
    required int type,
    required String emailOrPhone,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      _logger.info('Resetting password for $emailOrPhone');

      final response = await _apiClient.post(
        AppConstants.resetPasswordEndpoint,
        data: {
          'kod': code,
          'tur': type,
          'epostaTelefon': emailOrPhone,
          'sifre': password,
          'sifreDogrula': passwordConfirm,
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ResetPasswordResponse.fromJson(response.data);

        if (!apiResponse.basarili) {
          // Backend sometimes returns basarili: false but message indicates success
          // Check if message indicates success
          final mesaj = apiResponse.mesaj?.toLowerCase() ?? '';
          if (!mesaj.contains('başarı') && !mesaj.contains('success') &&
              !mesaj.contains('sıfırlandı') && !mesaj.contains('reset')) {
            throw AuthException(apiResponse.mesaj ?? 'Failed to reset password');
          }
        }

        _logger.info('Password reset successfully');
      } else {
        throw AuthException('Failed to reset password: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _logger.error('Error resetting password: ${e.message}');

      if (e.response?.statusCode == 400) {
        throw AuthException('Invalid reset code or passwords do not match');
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