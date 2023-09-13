import 'package:dio/dio.dart';
import 'package:qr/db/db_model/token_response_model.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';

class WebService {
  final String baseUrl;

  WebService(this.baseUrl);

  final Dio _dio = Dio();

  Future<String?> login(String email, String password) async {
    final url = baseUrl;
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
        TokenResponse tokenResponse = TokenResponse.fromJson(response.data);
        print(tokenResponse.token);
        if (tokenResponse.isSuccess) {
          await setToken(tokenResponse.token);
          return tokenResponse.token;
        }
      }
    }
    return null;
  }
}
