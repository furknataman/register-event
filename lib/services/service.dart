import 'package:dio/dio.dart';
import 'package:qr/db/db_model/token_response_model.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';
import 'package:qr/global/global_variable/global.dart';

class WebService {
  final String baseUrl;

  WebService(this.baseUrl);

  final Dio _dio = Dio();

  Future<void> getToken(String email, String password) async {
    final url = baseUrl;
    final data = {
      'email': email,
      'password': password,
    };

    try {
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

          // Token değerini yazdırır
          await TokenStorage.saveToken(tokenResponse.token);
        }
      } else {
        throw Exception('Failed to load token');
      }
    } catch (error) {
      rethrow;
    }
  }
}
