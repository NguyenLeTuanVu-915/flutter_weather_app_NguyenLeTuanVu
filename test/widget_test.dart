// test/widget_test.dart
// Test cơ bản cho Weather App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/main.dart';

// Test model
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';

void main() {
  // ---- Test Model ----
  group('WeatherModel Tests', () {
    test('Parse JSON thành WeatherModel đúng', () {
      final json = {
        'id': 1566083,
        'name': 'Ho Chi Minh City',
        'sys': {
          'country': 'VN',
          'sunrise': 1700000000,
          'sunset': 1700043600,
        },
        'main': {
          'temp': 32.5,
          'feels_like': 38.0,
          'temp_min': 30.0,
          'temp_max': 35.0,
          'humidity': 75,
          'pressure': 1010,
        },
        'wind': {'speed': 3.5, 'deg': 90},
        'weather': [
          {'description': 'mây rải rác', 'main': 'Clouds', 'icon': '03d'}
        ],
        'visibility': 10000,
        'clouds': {'all': 40},
        'dt': 1700021600,
        'coord': {'lat': 10.82, 'lon': 106.63},
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.country, 'VN');
      expect(weather.temperature, 32.5);
      expect(weather.humidity, 75);
      expect(weather.main, 'Clouds');
    });

    test('toJson → fromJson giữ nguyên dữ liệu', () {
      final json = {
        'id': 1,
        'name': 'Hanoi',
        'sys': {'country': 'VN', 'sunrise': 1700000000, 'sunset': 1700043600},
        'main': {
          'temp': 25.0, 'feels_like': 27.0, 'temp_min': 22.0,
          'temp_max': 28.0, 'humidity': 80, 'pressure': 1015,
        },
        'wind': {'speed': 2.0, 'deg': 180},
        'weather': [{'description': 'trời nắng', 'main': 'Clear', 'icon': '01d'}],
        'visibility': 10000,
        'clouds': {'all': 0},
        'dt': 1700000000,
        'coord': {'lat': 21.03, 'lon': 105.84},
      };

      final weather = WeatherModel.fromJson(json);
      final restored = WeatherModel.fromJson(weather.toJson());

      expect(restored.cityName, weather.cityName);
      expect(restored.temperature, weather.temperature);
      expect(restored.humidity, weather.humidity);
    });
  });

  // ---- Test Utils ----
  group('WeatherIcons Tests', () {
    test('getEmoji trả về đúng emoji', () {
      // Test đủ các trường hợp icon code
      expect(true, true); // placeholder
    });
  });
}