import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getAllEvents();
  Future<EventModel> getEventById(int id);
  Future<bool> registerForEvent(int userId, int eventId);
  Future<bool> unregisterFromEvent(int userId, int eventId);
  Future<bool> markAttendance(int userId, int eventId);
  Future<List<EventModel>> getUserRegisteredEvents(int userId);
  Future<List<EventModel>> getUserAttendedEvents(int userId);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  EventRemoteDataSourceImpl(this._apiClient, this._secureStorage);

  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      final token = await _secureStorage.getToken();
      
      final response = await _apiClient.post(
        '/AtcYonetim/MobilSunumlariListele',
        data: {'token': token},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        
        // Convert legacy response to new models
        return responseData.map((data) {
          final legacyModel = LegacyEventModel.fromJson(data);
          return legacyModel.toDomain().toModel();
        }).toList();
      } else {
        throw ServerException('Failed to load events: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<EventModel> getEventById(int id) async {
    try {
      final token = await _secureStorage.getToken();
      
      final response = await _apiClient.post(
        '/AtcYonetim/MobilSunumDetay',
        data: {'sunumId': id},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final legacyModel = LegacyEventModel.fromJson(response.data);
        return legacyModel.toDomain().toModel();
      } else {
        throw ServerException('Failed to load event details: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<bool> registerForEvent(int userId, int eventId) async {
    try {
      final token = await _secureStorage.getToken();
      
      final response = await _apiClient.post(
        '/AtcYonetim/SunumKayitEkle',
        data: {'katilimciId': userId, 'sunumId': eventId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        if (response.data['basarili'] == true) {
          return true;
        } else {
          throw ServerException('Registration failed: ${response.data['mesaj'] ?? 'Unknown error'}');
        }
      } else {
        throw ServerException('Failed to register for event: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<bool> unregisterFromEvent(int userId, int eventId) async {
    try {
      final token = await _secureStorage.getToken();
      
      final response = await _apiClient.post(
        '/AtcYonetim/SunumKayitSil',
        data: {'katilimciId': userId, 'sunumId': eventId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException('Failed to unregister from event: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<bool> markAttendance(int userId, int eventId) async {
    try {
      final token = await _secureStorage.getToken();
      
      final response = await _apiClient.post(
        '/AtcYonetim/SunumYoklamaAl',
        data: {'katilimciId': userId, 'sunumId': eventId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException('Failed to mark attendance: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<EventModel>> getUserRegisteredEvents(int userId) async {
    try {
      final token = await _secureStorage.getToken();
      
      final response = await _apiClient.post(
        '/AtcYonetim/KullaniciKayitlariListele',
        data: {'katilimciId': userId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        
        return responseData.map((data) {
          final legacyModel = LegacyEventModel.fromJson(data);
          return legacyModel.toDomain().toModel();
        }).toList();
      } else {
        throw ServerException('Failed to load registered events: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<EventModel>> getUserAttendedEvents(int userId) async {
    try {
      final token = await _secureStorage.getToken();
      
      final response = await _apiClient.post(
        '/AtcYonetim/KullaniciKatilimlariListele',
        data: {'katilimciId': userId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        
        return responseData.map((data) {
          final legacyModel = LegacyEventModel.fromJson(data);
          return legacyModel.toDomain().toModel();
        }).toList();
      } else {
        throw ServerException('Failed to load attended events: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  void _handleDioException(DioException e) {
    if (e.response?.statusCode == 401) {
      throw AuthException('Authentication token expired');
    } else if (e.response?.statusCode == 400) {
      throw AuthException('Bad request: ${e.response?.data['mesaj'] ?? 'Unknown error'}');
    } else if (e.type == DioExceptionType.connectionTimeout ||
               e.type == DioExceptionType.receiveTimeout ||
               e.type == DioExceptionType.sendTimeout) {
      throw NetworkException('Connection timeout. Please check your internet connection.');
    } else if (e.type == DioExceptionType.connectionError) {
      throw NetworkException('No internet connection available.');
    } else {
      throw ServerException('Server error: ${e.message}');
    }
  }
}