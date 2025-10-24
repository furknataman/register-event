import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:autumn_conference/core/data/models/presentation_model.dart';
import 'package:autumn_conference/core/data/models/session_response_model.dart';
import 'package:autumn_conference/core/data/models/token_response_model.dart';
import 'package:autumn_conference/core/data/models/user_info.dart';
import 'package:autumn_conference/core/data/local/token_stroge.dart';
import 'package:autumn_conference/main.dart';
import 'package:autumn_conference/core/notifications/toast/toast_message.dart';
import 'package:autumn_conference/core/services/network/check_internet.dart';

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
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  WebService() {
    _dio.interceptors.add(UnauthorizedException());
  }

  Future<Response> _makeRequest(String endpoint,
      {Map<String, dynamic>? data, String? token, String method = 'POST'}) async {
    final url = "$baseUrl$endpoint";

    final isConnected = await hasInternetConnection();
    if (!isConnected) {
      toastMessage("No internet connection");
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'No internet connection',
      );
    }

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
        data: {'id': id},
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
    final response = await _makeRequest("AtcYonetim/MobilTokenUret",
        data: {'email': email, 'password': password});

    if (response.statusCode == 200 && response.data["basarili"]) {
      TokenResponse tokenResponse = TokenResponse.fromJson(response.data);
      await setToken(tokenResponse.token);
      return tokenResponse.token;
    }
    return null;
  }

  Future<InfoUser> fetchUser() async {
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/MobilKullaniciBilgileriGetir",
        data: {'token': myToken}, token: myToken);

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

  Future<bool?> registerEvent(int userId, int presentationId) async {
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/SunumKayitEkle",
        data: {'katilimciId': userId, "sunumId": presentationId}, token: myToken);
    if (response.statusCode == 200) {
      if (response.data['basarili'] == true) {
        return true;
      }

      throw Exception('Failed to load presentations');
    } else {
      throw Exception('Failed to load presentations');
    }
  }

  Future<bool> removeEvent(int userId, int presentationId) async {
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/SunumKayitSil",
        data: {'katilimciId': userId, "sunumId": presentationId}, token: myToken);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load presentations');
    }
  }

  Future<bool> attendanceEvent(
      int userId, int presentationId, String successMessage) async {
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/SunumYoklamaAl",
        data: {'katilimciId': userId, "sunumId": presentationId}, token: myToken);
    if (response.statusCode == 200) {
      toastMessage(successMessage);
      return true;
    } else {
      throw Exception('Failed to load presentations');
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
}

final webServiceProvider = Provider<WebService>((ref) => WebService());

final userDataProvider = FutureProvider<InfoUser>((ref) async {
  return ref.watch(webServiceProvider).fetchUser();
});

final presentationDataProvider = FutureProvider<List<ClassModelPresentation>>((ref) async {
  return ref.watch(webServiceProvider).fetchAllEvents();
});

final sessionPresentationDataProvider = FutureProvider<SessionResponseModel>((ref) async {
  return ref.watch(webServiceProvider).fetchSessionPresentations();
});

// Event detail provider - Detay endpoint'inden zengin bilgi alıyoruz
final eventDetailsProvider =
    FutureProvider.family<ClassModelPresentation?, int>((ref, id) async {
  return ref.watch(webServiceProvider).fetchEventDetails(id);
});

// Seçili kategori için StateProvider
// 0 = Tümü, 1 = Oturum 1, 2 = Oturum 2, 3 = Oturum 3, 4 = Oturum 4, 5 = Kayıt Olduklarım
final selectedCategoryProvider = StateProvider<int>((ref) => 0);

// PageController için Provider - Event cards sayfaları için
final categoryPageControllerProvider = Provider<PageController>((ref) {
  final controller = PageController(initialPage: 0);
  ref.onDispose(() => controller.dispose());
  return controller;
});

// ScrollController için Provider - Kategori chips listesi için
final chipScrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// Bottom bar reset için StateProvider
final resetBottomBarProvider = StateProvider<int>((ref) => 0);
