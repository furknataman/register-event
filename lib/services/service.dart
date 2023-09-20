import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/presentation_model.dart';
import 'package:qr/db/db_model/token_response_model.dart';
import 'package:qr/db/db_model/user_info.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';
import 'package:qr/main.dart';

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
  final String baseUrl = "http://atc.eyuboglu.com/api/api/";
  final Dio _dio = Dio();
  WebService() {
    _dio.interceptors.add(UnauthorizedException());
  }

  Future<Response> _makeRequest(String endpoint,
      {Map<String, dynamic>? data, String? token}) async {
    final url = "$baseUrl$endpoint";
    final response = await _dio.post(
      url,
      data: data,
      options: _commonHeaders(token),
    );

    return response;
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
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/MobilSunumDetay",
        data: {
          'sunumId': id,
        },
        token: myToken);

    if (response.statusCode == 200) {
      ClassModelPresentation presentationDetails =
          ClassModelPresentation.fromJson(response.data);
      return presentationDetails;
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
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
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/MobilSunumlariListele",
        data: {'token': myToken}, token: myToken);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data;
      return responseData.map((data) => ClassModelPresentation.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load presentations');
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
}

final webServiceProvider = Provider<WebService>((ref) => WebService());

final userDataProvider = FutureProvider<InfoUser>((ref) async {
  return ref.watch(webServiceProvider).fetchUser();
});

final presentationDataProvider = FutureProvider<List<ClassModelPresentation>>((ref) async {
  return ref.watch(webServiceProvider).fetchAllEvents();
});

final eventDetailsProvider =
    FutureProvider.family<ClassModelPresentation?, int>((ref, id) async {
  return ref.watch(webServiceProvider).fetchEventDetails(id);
});


