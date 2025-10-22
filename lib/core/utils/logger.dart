import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppLogger {
  late final Logger _logger;

  AppLogger() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: _getLogLevel(),
    );
  }

  Level _getLogLevel() {
    // In production, you might want to set this to Level.warning or Level.error
    const bool kDebugMode = bool.fromEnvironment('dart.vm.product') == false;
    return kDebugMode ? Level.debug : Level.warning;
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // Network logging
  void logApiRequest(String method, String url, Map<String, dynamic>? data) {
    info('🌐 API Request: $method $url', data);
  }

  void logApiResponse(String method, String url, int statusCode, dynamic data) {
    if (statusCode >= 200 && statusCode < 300) {
      info('✅ API Response: $method $url [$statusCode]', data);
    } else {
      error('❌ API Error Response: $method $url [$statusCode]', data);
    }
  }

  void logApiError(String method, String url, dynamic error, [StackTrace? stackTrace]) {
    this.error('🚨 API Error: $method $url', error, stackTrace);
  }

  // Auth logging
  void logAuthEvent(String event, [Map<String, dynamic>? details]) {
    info('🔐 Auth Event: $event', details);
  }

  void logAuthError(String event, dynamic error, [StackTrace? stackTrace]) {
    this.error('🔐 Auth Error: $event', error, stackTrace);
  }

  // Navigation logging
  void logNavigation(String from, String to, [Map<String, dynamic>? params]) {
    debug('🧭 Navigation: $from -> $to', params);
  }

  // Cache logging
  void logCacheEvent(String event, String key, [dynamic data]) {
    debug('💾 Cache Event: $event [$key]', data);
  }

  // Performance logging
  void logPerformance(String operation, Duration duration, [Map<String, dynamic>? details]) {
    info('⚡ Performance: $operation took ${duration.inMilliseconds}ms', details);
  }

  // User action logging
  void logUserAction(String action, [Map<String, dynamic>? context]) {
    info('👤 User Action: $action', context);
  }

  // App lifecycle logging
  void logAppEvent(String event, [Map<String, dynamic>? details]) {
    info('📱 App Event: $event', details);
  }
}