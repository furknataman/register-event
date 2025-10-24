import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/logger.dart';
import '../models/event_model.dart';

abstract class EventLocalDataSource {
  Future<void> cacheEvents(List<EventModel> events);
  Future<List<EventModel>?> getCachedEvents();
  Future<void> cacheEvent(EventModel event);
  Future<EventModel?> getCachedEvent(int id);
  Future<void> clearCache();
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final AppLogger _logger;
  static const String _eventsKey = 'cached_events';
  static const String _eventPrefix = 'cached_event_';

  EventLocalDataSourceImpl(this._logger);

  @override
  Future<void> cacheEvents(List<EventModel> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = events.map((e) => e.toJson()).toList();
      await prefs.setString(_eventsKey, jsonEncode(eventsJson));
      
      // Also cache individual events for faster access
      for (final event in events) {
        await cacheEvent(event);
      }
    } catch (e) {
      // If caching fails, don't throw error - just log it
      _logger.logCacheEvent('Error', 'cache_events', e);
    }
  }

  @override
  Future<List<EventModel>?> getCachedEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsString = prefs.getString(_eventsKey);
      
      if (eventsString != null) {
        final List<dynamic> eventsJson = jsonDecode(eventsString);
        return eventsJson.map((json) => EventModel.fromJson(json)).toList();
      }
    } catch (e) {
      _logger.logCacheEvent('Error', 'get_cached_events', e);
    }
    return null;
  }

  @override
  Future<void> cacheEvent(EventModel event) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '$_eventPrefix${event.id}',
        jsonEncode(event.toJson()),
      );
    } catch (e) {
      _logger.logCacheEvent('Error', 'cache_event', e);
    }
  }

  @override
  Future<EventModel?> getCachedEvent(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventString = prefs.getString('$_eventPrefix$id');
      
      if (eventString != null) {
        final eventJson = jsonDecode(eventString);
        return EventModel.fromJson(eventJson);
      }
    } catch (e) {
      _logger.logCacheEvent('Error', 'get_cached_event', e);
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Remove all event-related cache
      final keys = prefs.getKeys().where((key) => 
        key == _eventsKey || key.startsWith(_eventPrefix)
      ).toList();
      
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      _logger.logCacheEvent('Error', 'clear_cache', e);
    }
  }
}