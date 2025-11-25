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
    required String code,
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
          _logger.warning('Login failed for user: $email');
          throw const AuthException('Login failed');
        }

        _logger.info('Login successful for user: $email');
        return apiResponse.toAuthResponse();
      } else {
        _logger.error('Unexpected status code: ${response.statusCode}');
        throw const AuthException('Login failed');
      }
    } on AuthException {
      rethrow;
    } on NetworkException {
      _logger.error('Network error during login');
      rethrow;
    } on ServerException {
      _logger.error('Server error during login');
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during login', e, stackTrace);
      throw ServerException('Unexpected error occurred');
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
        _logger.info('Registration successful for user: $email');
        return AuthResponse.fromJson(response.data);
      } else {
        _logger.error('Unexpected status code: ${response.statusCode}');
        throw const AuthException('Registration failed');
      }
    } on AuthException {
      rethrow;
    } on NetworkException {
      _logger.error('Network error during registration');
      rethrow;
    } on ServerException {
      _logger.error('Server error during registration');
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during registration', e, stackTrace);
      throw ServerException('Unexpected error occurred');
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
          'eposta': emailOrPhone,
          'tur': type,
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ForgotPasswordResponse.fromJson(response.data);

        // Handle status codes
        switch (apiResponse.status) {
          case 0: // Basarili
          case 2: // EpostaGonderildi
          case 4: // SmsGonderildi
            _logger.info('Password reset code sent successfully');
            return;
          case 1: // KatilimciBulunamadi
            throw const AuthException('forgot_password_participant_not_found');
          case 3: // EpostaYok
            throw const AuthException('forgot_password_email_not_found');
          case 5: // TelefonYok
            throw const AuthException('forgot_password_phone_not_found');
          case 6: // GecersizTur
            throw const AuthException('forgot_password_invalid_type');
          default:
            // Fallback to message check for backwards compatibility
            final mesaj = apiResponse.mesaj?.toLowerCase() ?? '';
            if (mesaj.contains('gönderildi') || mesaj.contains('sent')) {
              _logger.info('Password reset code sent successfully');
              return;
            }
            throw AuthException(apiResponse.mesaj ?? 'Failed to send reset code');
        }
      } else {
        throw AuthException('Failed to send reset code: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _logger.error('Error sending password reset code: ${e.message}');

      if (e.response?.statusCode == 404) {
        throw const AuthException('forgot_password_participant_not_found');
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
    required String code,
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
          'eposta': emailOrPhone,
          'sifre': password,
          'sifreDogrula': passwordConfirm,
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ResetPasswordResponse.fromJson(response.data);

        // Handle status codes
        switch (apiResponse.status) {
          case 0: // Basarili
            _logger.info('Password reset successfully');
            return;
          case 1: // KodGecersiz
            throw const AuthException('resetPassword_invalid_code');
          case 2: // KodSuresiDolmus
            throw const AuthException('resetPassword_code_expired');
          case 3: // SifrelerUyusmuyor
            throw const AuthException('resetPassword_passwords_mismatch');
          case 4: // GuncellemeBasarisiz
            throw const AuthException('resetPassword_update_failed');
          default:
            // Fallback to message check for backwards compatibility
            final mesaj = apiResponse.mesaj?.toLowerCase() ?? '';
            if (mesaj.contains('başarı') || mesaj.contains('success') ||
                mesaj.contains('sıfırlandı') || mesaj.contains('reset')) {
              _logger.info('Password reset successfully');
              return;
            }
            throw AuthException(apiResponse.mesaj ?? 'Failed to reset password');
        }
      } else {
        throw AuthException('Failed to reset password: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _logger.error('Error resetting password: ${e.message}');

      if (e.response?.statusCode == 400) {
        throw const AuthException('resetPassword_invalid_code');
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