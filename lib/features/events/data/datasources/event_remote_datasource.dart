import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/utils/logger.dart';
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
  final AppLogger _logger;

  EventRemoteDataSourceImpl(
    this._apiClient,
    this._secureStorage,
    this._logger,
  );

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
        throw ServerException('Failed to load events');
      }
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error loading events', e, stackTrace);
      throw ServerException('Failed to load events');
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
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in datasource', e, stackTrace);
      throw ServerException('Unexpected error occurred');
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
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in datasource', e, stackTrace);
      throw ServerException('Unexpected error occurred');
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
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in datasource', e, stackTrace);
      throw ServerException('Unexpected error occurred');
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
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in datasource', e, stackTrace);
      throw ServerException('Unexpected error occurred');
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
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in datasource', e, stackTrace);
      throw ServerException('Unexpected error occurred');
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
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in datasource', e, stackTrace);
      throw ServerException('Unexpected error occurred');
    }
  }

  // No longer needed - API client handles DioException automatically
  // with retry and connectivity interceptors
}