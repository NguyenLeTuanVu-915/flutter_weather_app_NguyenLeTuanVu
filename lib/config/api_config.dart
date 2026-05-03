import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {

  static String get apiKey =>
      dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static const String iconBaseUrl = 'https://openweathermap.org/img/wn';

  static String currentWeatherByCity(String city, {String unit = 'metric'}) =>
      '$baseUrl/weather?q=$city&appid=$apiKey&units=$unit';

  static String currentWeatherByCoord(double lat, double lon, {String unit = 'metric'}) =>
      '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=$unit';

  static String forecastByCity(String city, {String unit = 'metric'}) =>
      '$baseUrl/forecast?q=$city&appid=$apiKey&units=$unit';

  static String forecastByCoord(double lat, double lon, {String unit = 'metric'}) =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=$unit';

  static String weatherIconUrl(String iconCode) =>
      '$iconBaseUrl/$iconCode@2x.png';

  static const int cacheValidMinutes = 30;
}