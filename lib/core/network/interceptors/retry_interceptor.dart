import 'package:dio/dio.dart';
import '../../utils/logger.dart';

/// Retry interceptor for handling failed requests with exponential backoff
///
/// Automatically retries failed requests for:
/// - Network errors (connection timeout, connection error)
/// - Timeout errors (send timeout, receive timeout)
/// - 5xx server errors
/// - 429 Too Many Requests
///
/// Does NOT retry for:
/// - 4xx client errors (except 429)
/// - Request cancellation
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final List<Duration> retryDelays;
  final AppLogger _logger;

  RetryInterceptor({
    this.maxRetries = 3,
    List<Duration>? retryDelays,
  })  : retryDelays = retryDelays ??
            [
              const Duration(seconds: 1),
              const Duration(seconds: 2),
              const Duration(seconds: 4),
            ],
        _logger = AppLogger();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = err.requestOptions.extra['retry_attempt'] as int? ?? 0;

    // Check if we should retry
    if (attempt >= maxRetries || !_shouldRetry(err)) {
      _logger.error(
        'Request failed after $attempt attempts: ${err.requestOptions.path}',
      );
      return handler.next(err);
    }

    // Calculate delay for this attempt
    final delay = attempt < retryDelays.length
        ? retryDelays[attempt]
        : retryDelays.last;

    _logger.warning(
      'Retrying request (${attempt + 1}/$maxRetries) after ${delay.inSeconds}s: ${err.requestOptions.path}',
    );

    // Wait before retrying
    await Future.delayed(delay);

    // Update retry attempt counter
    err.requestOptions.extra['retry_attempt'] = attempt + 1;

    try {
      // Retry the request
      final response = await Dio().fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      // If retry fails, pass the error to the next error handler
      return super.onError(e, handler);
    }
  }

  /// Determines if the error is retryable
  bool _shouldRetry(DioException err) {
    // Don't retry if request was cancelled
    if (err.type == DioExceptionType.cancel) {
      return false;
    }

    // Retry on network errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on 5xx server errors and 429 Too Many Requests
    if (err.response != null) {
      final statusCode = err.response!.statusCode;
      if (statusCode != null) {
        return statusCode >= 500 || statusCode == 429;
      }
    }

    return false;
  }
}
