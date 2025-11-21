class AppConstants {
  // API
  static const String baseUrl = 'https://ibdayapi.eyuboglu.k12.tr/api';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Endpoints
  static const String sunumListeleEndpoint = '/Sunum/SunumListele';
  static const String loginEndpoint = '/Login/GirisYap';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String userEndpoint = '/user';
  static const String forgotPasswordEndpoint = '/Login/SifreUnuttum';
  static const String resetPasswordEndpoint = '/Login/SifreSifirla';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Routes
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String scanRoute = '/scan';
  static const String eventRoute = '/event';

  // App Info
  static const String appName = '18. IB Day - Better Together';
  static const String appVersion = '2.0.0';

  // Error Messages
  static const String networkError = 'Network connection error';
  static const String serverError = 'Server error occurred';
  static const String unauthorizedError = 'Unauthorized access';
  static const String unknownError = 'An unknown error occurred';
}
