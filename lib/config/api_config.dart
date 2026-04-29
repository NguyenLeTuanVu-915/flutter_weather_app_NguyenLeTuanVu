// lib/config/api_config.dart
// Cấu hình tất cả URL và endpoint của OpenWeatherMap API

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Lấy API key từ file .env
  static String get apiKey =>
      dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  // URL gốc của API
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // URL gốc của weather icon
  static const String iconBaseUrl = 'https://openweathermap.org/img/wn';

  // ---- Các endpoint ----

  /// Thời tiết hiện tại theo tên thành phố
  static String currentWeatherByCity(String city, {String unit = 'metric'}) =>
      '$baseUrl/weather?q=$city&appid=$apiKey&units=$unit';

  /// Thời tiết hiện tại theo tọa độ GPS
  static String currentWeatherByCoord(double lat, double lon, {String unit = 'metric'}) =>
      '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=$unit';

  /// Dự báo 5 ngày (mỗi 3 giờ) theo tên thành phố
  static String forecastByCity(String city, {String unit = 'metric'}) =>
      '$baseUrl/forecast?q=$city&appid=$apiKey&units=$unit';

  /// Dự báo 5 ngày theo tọa độ GPS
  static String forecastByCoord(double lat, double lon, {String unit = 'metric'}) =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=$unit';

  /// URL ảnh icon thời tiết (kích thước 2x)
  static String weatherIconUrl(String iconCode) =>
      '$iconBaseUrl/$iconCode@2x.png';

  // Thời gian cache hợp lệ: 30 phút
  static const int cacheValidMinutes = 30;
}