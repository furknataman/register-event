import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/Presentation.model.dart';
import 'package:qr/db/db_model/token_response_model.dart';
import 'package:qr/db/db_model/user_info.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';

class WebService {
  final String baseUrl = "http://atc.eyuboglu.com/api/api/";
  final Dio _dio = Dio();

  Future<Response> _makeRequest(String endpoint,
      {Map<String, dynamic>? data, String? token}) async {
    final url = "$baseUrl$endpoint";
    return await _dio.post(
      url,
      data: data,
      options: _commonHeaders(token),
    );
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

  Future<Presentation?> fetchEventDetails(int id) async {
    print(id);
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/MobilSunumDetay",
        data: {
          'sunumId': id,
        },
        token: myToken);

    if (response.statusCode == 200) {
      Presentation presentationDetails = Presentation.fromJson(response.data);
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

  Future<List<Presentation>> fetchAllEvents() async {
    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/MobilSunumlariListele",
        data: {'token': myToken}, token: myToken);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data;
      return responseData.map((data) => Presentation.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load presentations');
    }
  }

  Future<TokenResponse> registerEvent(int presentationId) async {
    int userId = 0; //TODO add user id

    final myToken = await getToken();
    final response = await _makeRequest("AtcYonetim/SunumKayitEkle",
        data: {'katilimciId': userId, "sunumId": presentationId}, token: myToken);

    if (response.statusCode == 200) {
      TokenResponse tokenResponse = TokenResponse.fromJson(response.data);
      return tokenResponse;
    } else {
      throw Exception('Failed to load presentations');
    }
  }
}

final webServiceProvider = Provider<WebService>((ref) => WebService());

final userDataProvider = FutureProvider<InfoUser>((ref) async {
  return ref.watch(webServiceProvider).fetchUser();
});

final presentationDataProvider = FutureProvider<List<Presentation>>((ref) async {
  return ref.watch(webServiceProvider).fetchAllEvents();
});

final eventDetailsProvider = FutureProvider.family<Presentation?, int>((ref, id) async {
  return ref.watch(webServiceProvider).fetchEventDetails(id);
});

final registerEventProvider =
    FutureProvider.family<TokenResponse?, int>((ref, presentationId) async {
  return ref.watch(webServiceProvider).registerEvent(presentationId);
});
