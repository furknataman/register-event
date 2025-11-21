import 'package:flutter/foundation.dart';

import '../utils/logger.dart';
import 'failures.dart';
import 'exceptions.dart';

class ErrorHandler {
  final AppLogger _logger;

  ErrorHandler(this._logger);

  // Convert exceptions to failures
  Failure handleException(Exception exception, [StackTrace? stackTrace]) {
    _logger.error('Exception occurred', exception, stackTrace);

    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is AuthException) {
      return AuthFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else {
      return ServerFailure('An unexpected error occurred: ${exception.toString()}');
    }
  }

  // Handle generic errors
  Failure handleError(dynamic error, [StackTrace? stackTrace]) {
    _logger.error('Error occurred', error, stackTrace);

    if (error is Exception) {
      return handleException(error, stackTrace);
    } else {
      return ServerFailure('An unexpected error occurred: ${error.toString()}');
    }
  }

  // Log and handle critical errors
  void handleCriticalError(
    dynamic error, 
    StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? additionalInfo,
  }) {
    final errorContext = {
      'context': context ?? 'Unknown',
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
      if (additionalInfo != null) ...additionalInfo,
    };

    _logger.fatal(
      'Critical error occurred${context != null ? ' in $context' : ''}',
      error,
      stackTrace,
    );

    // In production, you might want to send this to a crash reporting service
    if (kReleaseMode) {
      _sendToCrashReporting(error, stackTrace, errorContext);
    }
  }

  // Handle network-related errors specifically
  Failure handleNetworkError(dynamic error, [StackTrace? stackTrace]) {
    _logger.logApiError('Network', 'Unknown', error, stackTrace);

    if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else {
      return NetworkFailure('Network error occurred: ${error.toString()}');
    }
  }

  // Handle authentication-related errors specifically  
  Failure handleAuthError(dynamic error, [StackTrace? stackTrace]) {
    _logger.logAuthError('Authentication', error, stackTrace);

    if (error is AuthException) {
      return AuthFailure(error.message);
    } else {
      return AuthFailure('Authentication error occurred: ${error.toString()}');
    }
  }

  // Validate and handle validation errors
  Failure handleValidationError(List<String> validationErrors) {
    final errorMessage = validationErrors.join(', ');
    _logger.warning('Validation failed', {'errors': validationErrors});
    return ValidationFailure(errorMessage);
  }

  // Handle cache-related errors
  Failure handleCacheError(dynamic error, [StackTrace? stackTrace]) {
    _logger.logCacheEvent('Error', 'cache_operation', error);
    
    if (error is CacheException) {
      return CacheFailure(error.message);
    } else {
      return CacheFailure('Cache error occurred: ${error.toString()}');
    }
  }

  // Get user-friendly error message
  String getUserFriendlyMessage(Failure failure) {
    // This returns English messages for backward compatibility
    // Use getLocalizedMessageKey() for localized messages
    switch (failure.runtimeType) {
      case const (NetworkFailure):
        return 'Please check your internet connection and try again.';
      case const (AuthFailure):
        return 'Authentication failed. Please log in again.';
      case const (ValidationFailure):
        return 'Please check your input and try again.';
      case const (CacheFailure):
        return 'There was a problem loading cached data.';
      case const (ServerFailure):
      default:
        return 'Something went wrong. Please try again later.';
    }
  }

  // Get localization key for the failure
  // Use this with AppLocalizations for localized error messages
  String getLocalizedMessageKey(Failure failure) {
    final message = failure.message.toLowerCase();

    // Check specific error messages first
    if (message.contains('timeout')) {
      return 'timeoutError';
    } else if (message.contains('connection') || message.contains('internet')) {
      return 'networkError';
    } else if (message.contains('cancelled') || message.contains('cancel')) {
      return 'requestCancelled';
    }

    // Then check failure types
    switch (failure.runtimeType) {
      case const (NetworkFailure):
        return 'networkError';
      case const (AuthFailure):
        return 'authenticationError';
      case const (ValidationFailure):
        return 'validationError';
      case const (CacheFailure):
        return 'dataParseError';
      case const (ServerFailure):
        return 'serverError';
      default:
        return 'unknownError';
    }
  }

  // Check if error is recoverable
  bool isRecoverableError(Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkFailure):
      case const (ServerFailure):
        return true;
      case const (AuthFailure):
      case const (ValidationFailure):
      case const (CacheFailure):
        return false;
      default:
        return false;
    }
  }

  void _sendToCrashReporting(
    dynamic error, 
    StackTrace stackTrace, 
    Map<String, dynamic> context,
  ) {
    // TODO: Implement crash reporting service integration
    // Examples: Firebase Crashlytics, Sentry, etc.
    _logger.info('Would send to crash reporting service', {
      'error': error.toString(),
      'context': context,
    });
  }
}