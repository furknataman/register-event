import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/Presentation.model.dart';
import 'package:qr/db/db_model/token_response_model.dart';
import 'package:qr/db/db_model/user_info.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';

class WebService {
  final baseUrl = "http://atc.eyuboglu.com/api/api/";
  final Dio _dio = Dio();

  Future<String?> login(String email, String password) async {
    final url = "${baseUrl}AtcYonetim/MobilTokenUret";
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

  Future<InfoUser> fetchUser() async {
    String? myToken = await getToken();

    final url = "${baseUrl}AtcYonetim/MobilKullaniciBilgileriGetir";

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
      throw Exception('Failed to load presentations');
    }
  }

  Future<List<Presentation>> fetchAllEvents() async {
    String? myToken = await getToken();

    final url = "${baseUrl}AtcYonetim/MobilSunumlariListele";

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
        final List<dynamic> responseData = response.data;

        List<Presentation> events =
            responseData.map((data) => Presentation.fromJson(data)).toList();
        print(events.first.id);
        return responseData.map((data) => Presentation.fromJson(data)).toList();
      }
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
