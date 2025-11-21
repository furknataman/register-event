import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../utils/logger.dart';

/// Connectivity interceptor that checks internet connection before making requests
///
/// If there's no internet connection:
/// - Waits for connection to be restored
/// - Automatically retries the request when connection is available
/// - Logs connectivity status changes
class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity;
  final AppLogger _logger;
  final Duration _connectionTimeout;

  ConnectivityInterceptor({
    Connectivity? connectivity,
    Duration? connectionTimeout,
  })  : _connectivity = connectivity ?? Connectivity(),
        _connectionTimeout = connectionTimeout ?? const Duration(seconds: 30),
        _logger = AppLogger();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check current connectivity status
    final connectivityResult = await _connectivity.checkConnectivity();

    if (_isConnected(connectivityResult)) {
      // Connection available, proceed with request
      return handler.next(options);
    }

    // No connection, wait for it to be restored
    _logger.warning(
      'No internet connection, waiting for connectivity: ${options.path}',
    );

    try {
      // Wait for connection with timeout
      await _waitForConnection();
      _logger.info('Connection restored, proceeding with request: ${options.path}');
      return handler.next(options);
    } on TimeoutException {
      _logger.error('Connection timeout while waiting for internet');
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection',
        ),
      );
    }
  }

  /// Checks if device is connected to internet
  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }

  /// Waits for internet connection to be restored
  Future<void> _waitForConnection() async {
    final completer = Completer<void>();

    // Set up timeout
    final timeoutTimer = Timer(_connectionTimeout, () {
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException('Connection timeout'));
      }
    });

    // Listen to connectivity changes
    StreamSubscription<List<ConnectivityResult>>? subscription;
    subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (_isConnected(results)) {
        timeoutTimer.cancel();
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    return completer.future;
  }
}
