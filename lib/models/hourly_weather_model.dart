// lib/models/hourly_weather_model.dart
// Model cho dự báo thời tiết theo từng giờ (từ API /forecast)

class HourlyWeatherModel {
  final DateTime dateTime;       // Thời gian dự báo
  final double temperature;      // Nhiệt độ (°C)
  final double feelsLike;        // Cảm giác như (°C)
  final String description;      // Mô tả thời tiết
  final String main;             // Trạng thái chính
  final String iconCode;         // Mã icon
  final int humidity;            // Độ ẩm (%)
  final double windSpeed;        // Tốc độ gió (m/s)
  final int cloudiness;          // Độ che phủ mây (%)
  final double? rainVolume;      // Lượng mưa 3 giờ (mm)
  final double popPercent;       // Xác suất mưa (0.0 - 1.0)

  HourlyWeatherModel({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.main,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.cloudiness,
    this.rainVolume,
    required this.popPercent,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] ?? 0) * 1000,
      ),
      temperature: (json['main']?['temp'] ?? 0.0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0.0).toDouble(),
      description: json['weather']?[0]?['description'] ?? '',
      main: json['weather']?[0]?['main'] ?? '',
      iconCode: json['weather']?[0]?['icon'] ?? '01d',
      humidity: json['main']?['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
      cloudiness: json['clouds']?['all'] ?? 0,
      rainVolume: json['rain']?['3h']?.toDouble(),
      popPercent: (json['pop'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
      },
      'weather': [{'description': description, 'main': main, 'icon': iconCode}],
      'wind': {'speed': windSpeed},
      'clouds': {'all': cloudiness},
      'pop': popPercent,
      if (rainVolume != null) 'rain': {'3h': rainVolume},
    };
  }

  int get tempRounded => temperature.round();
  int get popPercent100 => (popPercent * 100).round();
}