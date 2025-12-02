import 'package:autumn_conference/core/data/local/token_stroge.dart';
import 'package:autumn_conference/core/data/models/presentation_model.dart';
import 'package:autumn_conference/core/data/models/session_response_model.dart';
import 'package:autumn_conference/core/data/models/token_response_model.dart';
import 'package:autumn_conference/core/data/models/user_info.dart';
import 'package:autumn_conference/core/notifications/toast/toast_message.dart';
import 'package:autumn_conference/features/notifications/data/models/notification_model.dart';
import 'package:autumn_conference/features/schedule/data/models/program_model.dart';
import 'package:autumn_conference/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class UnauthorizedException extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 400 || response.statusCode == 401) {
      await logout();
      await navigatorKey.currentState?.pushReplacementNamed('/start');
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
      await logout();

      await navigatorKey.currentState?.pushReplacementNamed('/start');
    }
    super.onError(err, handler);
  }
}

class WebService {
  final String baseUrl = "https://ibdayapi.eyuboglu.k12.tr/api";
  final Dio _dio = Dio();
  final Logger _logger = Logger(
    printer: SimplePrinter(
      colors: false,
      printTime: false,
    ),
  );

  WebService() {
    _dio.interceptors.add(UnauthorizedException());
  }

  Future<Response> _makeRequest(String endpoint,
      {Map<String, dynamic>? data, String? token, String method = 'POST'}) async {
    final url = "$baseUrl/$endpoint";

    try {
      final response = method == 'GET'
          ? await _dio.get(
              url,
              queryParameters: data,
              options: token != null ? _commonHeaders(token) : null,
            )
          : await _dio.post(
              url,
              data: data,
              options: token != null ? _commonHeaders(token) : null,
            );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Options _commonHeaders([String? token]) {
    final headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return Options(headers: headers);
  }

  Future<ClassModelPresentation?> fetchEventDetails(int id) async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Sunum/SunumDetay";
      _logger.i('Fetching event details for ID: $id from: $url');

      final response = await _dio.post(
        url,
        data: {'sunumId': id},
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data type: ${response.data.runtimeType}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200) {
        _logger.i('Successfully loaded event details for ID: $id');
        return ClassModelPresentation.fromJson(response.data);
      } else {
        throw Exception('Failed to load event details: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching event details for ID: $id', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<String?> login(String email, String password) async {
    await logout();
    final response = await _makeRequest("AtcYonetim/MobilTokenUret", data: {'email': email, 'password': password});

    if (response.statusCode == 200 && response.data["basarili"]) {
      TokenResponse tokenResponse = TokenResponse.fromJson(response.data);
      await setToken(tokenResponse.token);
      return tokenResponse.token;
    }
    return null;
  }

  Future<InfoUser> fetchUser() async {
    final myToken = await getToken();
    final response =
        await _makeRequest("AtcYonetim/MobilKullaniciBilgileriGetir", data: {'token': myToken}, token: myToken);

    if (response.statusCode == 200) {
      return InfoUser.fromJson(response.data);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<List<ClassModelPresentation>> fetchAllEvents() async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Sunum/SunumListele";
      _logger.i('Fetching events from: $url');

      final response = await _dio.get(
        url,
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        _logger.i('Successfully loaded ${responseData.length} events');
        return responseData.map((data) => ClassModelPresentation.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load presentations: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching events', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<InfoUser> fetchUserProfile() async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Login/KatilimciBilgiGetir";
      _logger.i('Fetching user profile from: $url');

      final response = await _dio.get(
        url,
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200) {
        _logger.i('Successfully loaded user profile');
        return InfoUser.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching user profile', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<bool?> registerEvent(int userId, int presentationId) async {
    try {
      _logger.i('🔵 REGISTER EVENT CALLED - userId: $userId, presentationId: $presentationId');
      final myToken = await getToken();
      _logger.i('🔵 Token retrieved: ${myToken != null ? "✓" : "✗"}');

      final response = await _makeRequest("Sunum/SunumKayitEkle", data: {"sunumId": presentationId}, token: myToken);

      _logger.i('🔵 Response status: ${response.statusCode}');
      _logger.i('🔵 Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['sonuc'] == 1) {
          _logger.i('✅ Successfully registered for event. Message: ${response.data['mesaj']}');
          return true;
        }

        _logger.e('❌ Registration failed - sonuc != 1. Data: ${response.data}');
        throw Exception('Failed to register: ${response.data['mesaj']}');
      } else {
        _logger.e('❌ Registration failed - status: ${response.statusCode}');
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('❌ REGISTER EVENT ERROR', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<bool> removeEvent(int userId, int presentationId) async {
    try {
      _logger.i('🔴 REMOVE EVENT CALLED - userId: $userId, presentationId: $presentationId');
      final myToken = await getToken();
      _logger.i('🔴 Token retrieved: ${myToken != null ? "✓" : "✗"}');

      final response = await _makeRequest("Sunum/SunumKayitSil", data: {"sunumId": presentationId}, token: myToken);

      _logger.i('🔴 Response status: ${response.statusCode}');
      _logger.i('🔴 Response data: ${response.data}');

      if (response.statusCode == 200) {
        // API başarılı response'da 'sonuc' field'ı dönmüyor, sadece 'mesaj' var
        // Eğer 'mesaj' varsa başarılı demektir
        if (response.data['mesaj'] != null && response.data['mesaj'].toString().isNotEmpty) {
          _logger.i('✅ Successfully removed from event. Message: ${response.data['mesaj']}');
          return true;
        }
        _logger.e('❌ Remove failed - no message in response. Data: ${response.data}');
        throw Exception('Failed to remove: No message in response');
      } else {
        _logger.e('❌ Remove failed - status: ${response.statusCode}');
        throw Exception('Failed to remove: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('❌ REMOVE EVENT ERROR', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<bool> attendanceEvent(int userId, int presentationId, String successMessage) async {
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/SunumYoklamaAl", data: {"sunumId": presentationId}, token: myToken);
    if (response.statusCode == 200) {
      if (response.data['sonuc'] == 1) {
        toastMessage(successMessage);
        _logger.i('Attendance marked successfully. Message: ${response.data['mesaj']}');
        return true;
      }
      throw Exception('Failed to mark attendance: ${response.data['mesaj']}');
    } else {
      throw Exception('Failed to mark attendance: ${response.statusCode}');
    }
  }

  Future<SessionResponseModel> fetchSessionPresentations() async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Sunum/SunumKayitGetir";
      _logger.i('Fetching session presentations from: $url');

      final response = await _dio.get(
        url,
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        _logger.i('Successfully loaded session presentations');
        return SessionResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load session presentations: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching session presentations', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<ProgramModel>> fetchProgramFlow() async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Sunum/ProgramAkisi";
      _logger.i('Fetching program flow from: $url');

      final response = await _dio.get(
        url,
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        _logger.i('Successfully loaded ${responseData.length} program entries');
        return responseData.map((data) => ProgramModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load program flow: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching program flow', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<String?> getLanguage() async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Language/GetLanguage";
      _logger.i('Fetching language preference from: $url');

      final response = await _dio.get(
        url,
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200) {
        _logger.i('Successfully retrieved language preference');
        return response.data.toString();
      } else {
        _logger.w('Failed to get language: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching language', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<bool> updateLanguage(String languageCode) async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Language/UpdateLanguage?language=$languageCode";
      _logger.i('Updating language preference to: $languageCode');

      final response = await _dio.post(
        url,
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200) {
        _logger.i('Successfully updated language preference to: $languageCode');
        return true;
      } else {
        _logger.w('Failed to update language: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e('Error updating language', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<NotificationResponseModel> getNotifications(int page) async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Notification/GetNotifications?page=$page";
      _logger.i('Fetching notifications from: $url (page: $page)');

      final response = await _dio.get(
        url,
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        _logger.i('Successfully loaded notifications for page: $page');
        return NotificationResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching notifications', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<UnreadCountResponseModel> getUnreadCount() async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Notification/GetUnreadCount";
      _logger.i('Fetching unread count from: $url');

      final response = await _dio.get(
        url,
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200) {
        _logger.i('Successfully loaded unread count');
        return UnreadCountResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load unread count: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching unread count', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Notification/MarkAsRead";
      _logger.i('Marking notification as read: $notificationId');

      final response = await _dio.post(
        url,
        data: {'notificationId': notificationId},
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        _logger.i('Successfully marked notification as read: $notificationId');
        return true;
      } else {
        _logger.w('Failed to mark notification as read: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e('Error marking notification as read', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> registerFcmToken(
    String fcmToken,
    String deviceType,
    String deviceInfo,
  ) async {
    try {
      final myToken = await getToken();
      final url = "$baseUrl/Notification/RegisterToken";
      _logger.i('Registering FCM token - Device: $deviceType, Info: $deviceInfo');

      final response = await _dio.post(
        url,
        data: {
          'token': fcmToken,
          'deviceType': deviceType,
          'deviceInfo': deviceInfo,
        },
        options: myToken != null ? _commonHeaders(myToken) : null,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200) {
        _logger.i('Successfully registered FCM token');
        return true;
      } else {
        _logger.w('Failed to register FCM token: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e('Error registering FCM token', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}

final webServiceProvider = Provider<WebService>((ref) => WebService());

final userDataProvider = FutureProvider<InfoUser>((ref) async {
  return ref.watch(webServiceProvider).fetchUser();
});

final userProfileProvider = FutureProvider.autoDispose<InfoUser>((ref) async {
  return ref.watch(webServiceProvider).fetchUserProfile();
});

final presentationDataProvider = FutureProvider<List<ClassModelPresentation>>((ref) async {
  return ref.watch(webServiceProvider).fetchAllEvents();
});

final sessionPresentationDataProvider = FutureProvider<SessionResponseModel>((ref) async {
  return ref.watch(webServiceProvider).fetchSessionPresentations();
});

final programFlowProvider = FutureProvider<List<ProgramModel>>((ref) async {
  return ref.watch(webServiceProvider).fetchProgramFlow();
});

// Event detail provider - Detay endpoint'inden zengin bilgi alıyoruz
final eventDetailsProvider = FutureProvider.family<ClassModelPresentation?, int>((ref, id) async {
  return ref.watch(webServiceProvider).fetchEventDetails(id);
});
