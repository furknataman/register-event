import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/token_response_model.dart';
import 'package:qr/db/db_model/user_info.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebService {
  final String shortUrl;

  WebService(this.shortUrl);
  final baseUrl = "http://atc.eyuboglu.com/api/api/";
  final Dio _dio = Dio();

  Future<String?> login(String email, String password) async {
    final url = baseUrl + shortUrl;
    final data = {
      'email': email,
      'password': password,
    };

    Response response = await _dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      {
        if (response.data["basarili"]) {
          TokenResponse tokenResponse = TokenResponse.fromJson(response.data);

          await setToken(tokenResponse.token);
          return tokenResponse.token;
        }
      }
    }
    return null;
  }

  Future<InfoUser?> fetchUser() async {
    String? myToken = await getToken();

    final url = baseUrl + shortUrl;

    Response response = await _dio.post(
      url,
      data: {'token': myToken},
      options: Options(
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $myToken',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      {
        InfoUser infoUser = InfoUser.fromJson(response.data);
        return infoUser;
      }
    } else {
      return null;
    }
  }
}

final userProvider =
    Provider<WebService>((ref) => WebService("AtcYonetim/MobilKullaniciBilgileriGetir"));

final userDataProvider = FutureProvider<InfoUser?>((ref) async {
  return ref.watch(userProvider).fetchUser();
});
