// lib/services/weather_service.dart
// Gọi API OpenWeatherMap và parse dữ liệu

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/hourly_weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final http.Client _client;

  // Cho phép inject client (dùng cho testing)
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  // ---- Thời tiết hiện tại ----

  /// Lấy thời tiết hiện tại theo tên thành phố
  Future<WeatherModel> getCurrentWeatherByCity(String city, {String unit = 'metric'}) async {
    final url = ApiConfig.currentWeatherByCity(city, unit: unit);
    return await _fetchCurrentWeather(url);
  }

  /// Lấy thời tiết hiện tại theo tọa độ GPS
  Future<WeatherModel> getCurrentWeatherByCoord(double lat, double lon, {String unit = 'metric'}) async {
    final url = ApiConfig.currentWeatherByCoord(lat, lon, unit: unit);
    return await _fetchCurrentWeather(url);
  }

  /// Gọi API và parse thời tiết hiện tại (dùng chung)
  Future<WeatherModel> _fetchCurrentWeather(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('API key không hợp lệ. Kiểm tra lại file .env');
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy thành phố. Vui lòng kiểm tra lại tên.');
      } else if (response.statusCode == 429) {
        throw Exception('Đã vượt giới hạn API. Vui lòng thử lại sau.');
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Lỗi kết nối: Kiểm tra internet và thử lại.');
    }
  }

  // ---- Dự báo thời tiết ----

  /// Lấy dự báo 5 ngày theo tên thành phố
  Future<List<DailyForecastModel>> getForecastByCity(String city, {String unit = 'metric'}) async {
    final url = ApiConfig.forecastByCity(city, unit: unit);
    return await _fetchForecast(url);
  }

  /// Lấy dự báo 5 ngày theo tọa độ
  Future<List<DailyForecastModel>> getForecastByCoord(double lat, double lon, {String unit = 'metric'}) async {
    final url = ApiConfig.forecastByCoord(lat, lon, unit: unit);
    return await _fetchForecast(url);
  }

  /// Lấy danh sách HourlyWeatherModel thô (dùng khi cần cache)
  Future<List<HourlyWeatherModel>> getHourlyByCity(String city, {String unit = 'metric'}) async {
    final url = ApiConfig.forecastByCity(city, unit: unit);
    final response = await _client
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Lỗi lấy dự báo: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final List list = json['list'] ?? [];
    return list
        .map((item) => HourlyWeatherModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Gọi API và nhóm theo ngày để tạo DailyForecastModel
  Future<List<DailyForecastModel>> _fetchForecast(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Lỗi lấy dự báo: ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final List list = json['list'] ?? [];

      final hourlyList = list
          .map((item) => HourlyWeatherModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return _groupByDay(hourlyList);
    } catch (e) {
      throw Exception('Lỗi tải dự báo: ${e.toString()}');
    }
  }

  /// Nhóm danh sách hourly thành daily forecast
  List<DailyForecastModel> _groupByDay(List<HourlyWeatherModel> hourlyList) {
    final Map<String, List<HourlyWeatherModel>> grouped = {};

    for (final item in hourlyList) {
      final dayKey =
          '${item.dateTime.year}-${item.dateTime.month.toString().padLeft(2, '0')}-${item.dateTime.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(dayKey, () => []);
      grouped[dayKey]!.add(item);
    }

    final List<DailyForecastModel> dailyList = [];
    for (final entry in grouped.entries) {
      final date = entry.value.first.dateTime;
      dailyList.add(DailyForecastModel.fromHourlyList(date, entry.value));
    }

    dailyList.sort((a, b) => a.date.compareTo(b.date));
    return dailyList;
  }
}