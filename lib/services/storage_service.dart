import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _forecastKey = 'cached_forecast';
  static const String _weatherTimestampKey = 'weather_timestamp';
  static const String _forecastTimestampKey = 'forecast_timestamp';
  static const String _lastCityKey = 'last_city';
  static const String _searchHistoryKey = 'search_history';
  static const String _unitKey = 'temperature_unit';
  static const String _favoritesKey = 'favorite_cities';

  Future<void> cacheWeather(Map<String, dynamic> weatherJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, jsonEncode(weatherJson));
    await prefs.setInt(
      _weatherTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<Map<String, dynamic>?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_weatherKey);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> cacheForecast(List<Map<String, dynamic>> forecastJsonList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_forecastKey, jsonEncode(forecastJsonList));
    await prefs.setInt(
      _forecastTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<List<Map<String, dynamic>>?> getCachedForecast() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_forecastKey);
    if (jsonString == null) return null;
    final List<dynamic> list = jsonDecode(jsonString);
    return list.cast<Map<String, dynamic>>();
  }

  Future<bool> isWeatherCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_weatherTimestampKey);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cachedTime).inMinutes;

    return difference < ApiConfig.cacheValidMinutes;
  }

  Future<void> saveLastCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCityKey, cityName);
  }

  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCityKey);
  }

  Future<void> saveSearchHistory(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_searchHistoryKey);
    List<String> history = historyJson != null
        ? List<String>.from(jsonDecode(historyJson))
        : [];

    history.remove(cityName);
    history.insert(0, cityName);
    if (history.length > 10) history = history.sublist(0, 10);

    await prefs.setString(_searchHistoryKey, jsonEncode(history));
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_searchHistoryKey);
    if (historyJson == null) return [];
    return List<String>.from(jsonDecode(historyJson));
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  Future<void> saveFavorites(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, jsonEncode(cities));
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favJson = prefs.getString(_favoritesKey);
    if (favJson == null) return [];
    return List<String>.from(jsonDecode(favJson));
  }

  Future<void> saveTemperatureUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit);
  }

  Future<String> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_unitKey) ?? 'metric';
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherKey);
    await prefs.remove(_forecastKey);
    await prefs.remove(_weatherTimestampKey);
    await prefs.remove(_forecastTimestampKey);
  }
}