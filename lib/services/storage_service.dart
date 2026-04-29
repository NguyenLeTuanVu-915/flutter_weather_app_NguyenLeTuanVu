// lib/services/storage_service.dart
// Lưu và load dữ liệu từ SharedPreferences (cache offline)

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class StorageService {
  // Keys để lưu trong SharedPreferences
  static const String _weatherKey = 'cached_weather';
  static const String _forecastKey = 'cached_forecast';
  static const String _weatherTimestampKey = 'weather_timestamp';
  static const String _forecastTimestampKey = 'forecast_timestamp';
  static const String _lastCityKey = 'last_city';
  static const String _searchHistoryKey = 'search_history';
  static const String _unitKey = 'temperature_unit';
  static const String _favoritesKey = 'favorite_cities';

  // ---- WEATHER CACHE ----

  /// Lưu dữ liệu thời tiết vào cache
  Future<void> cacheWeather(Map<String, dynamic> weatherJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, jsonEncode(weatherJson));
    // Lưu thời gian cache để kiểm tra còn hạn không
    await prefs.setInt(
      _weatherTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Load dữ liệu thời tiết từ cache
  Future<Map<String, dynamic>?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_weatherKey);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Lưu dự báo thời tiết vào cache
  Future<void> cacheForecast(List<Map<String, dynamic>> forecastJsonList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_forecastKey, jsonEncode(forecastJsonList));
    await prefs.setInt(
      _forecastTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Load dự báo từ cache
  Future<List<Map<String, dynamic>>?> getCachedForecast() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_forecastKey);
    if (jsonString == null) return null;
    final List<dynamic> list = jsonDecode(jsonString);
    return list.cast<Map<String, dynamic>>();
  }

  /// Kiểm tra cache thời tiết còn hạn không (30 phút)
  Future<bool> isWeatherCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_weatherTimestampKey);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cachedTime).inMinutes;

    return difference < ApiConfig.cacheValidMinutes;
  }

  // ---- CITY ----

  /// Lưu tên thành phố cuối cùng tìm kiếm
  Future<void> saveLastCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCityKey, cityName);
  }

  /// Load tên thành phố cuối cùng
  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCityKey);
  }

  // ---- SEARCH HISTORY ----

  /// Lưu lịch sử tìm kiếm (tối đa 10 thành phố)
  Future<void> saveSearchHistory(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_searchHistoryKey);
    List<String> history = historyJson != null
        ? List<String>.from(jsonDecode(historyJson))
        : [];

    // Xóa nếu đã có trong lịch sử (tránh trùng lặp)
    history.remove(cityName);
    // Thêm vào đầu danh sách
    history.insert(0, cityName);
    // Giới hạn 10 mục
    if (history.length > 10) history = history.sublist(0, 10);

    await prefs.setString(_searchHistoryKey, jsonEncode(history));
  }

  /// Load lịch sử tìm kiếm
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_searchHistoryKey);
    if (historyJson == null) return [];
    return List<String>.from(jsonDecode(historyJson));
  }

  /// Xóa lịch sử tìm kiếm
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  // ---- FAVORITES ----

  /// Lưu danh sách thành phố yêu thích (tối đa 5)
  Future<void> saveFavorites(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, jsonEncode(cities));
  }

  /// Load danh sách thành phố yêu thích
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favJson = prefs.getString(_favoritesKey);
    if (favJson == null) return [];
    return List<String>.from(jsonDecode(favJson));
  }

  // ---- SETTINGS ----

  /// Lưu đơn vị nhiệt độ (metric = Celsius, imperial = Fahrenheit)
  Future<void> saveTemperatureUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit);
  }

  /// Load đơn vị nhiệt độ
  Future<String> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_unitKey) ?? 'metric';
  }

  /// Xóa toàn bộ cache
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherKey);
    await prefs.remove(_forecastKey);
    await prefs.remove(_weatherTimestampKey);
    await prefs.remove(_forecastTimestampKey);
  }
}