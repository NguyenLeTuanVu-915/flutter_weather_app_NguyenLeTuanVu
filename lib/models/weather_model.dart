// lib/models/weather_model.dart
// Model cho dữ liệu thời tiết hiện tại từ OpenWeatherMap

class WeatherModel {
  final int id;                    // ID thành phố
  final String cityName;           // Tên thành phố
  final String country;            // Mã quốc gia (VN, US,...)
  final double temperature;        // Nhiệt độ hiện tại (°C)
  final double feelsLike;          // Cảm giác như (°C)
  final double tempMin;            // Nhiệt độ thấp nhất
  final double tempMax;            // Nhiệt độ cao nhất
  final int humidity;              // Độ ẩm (%)
  final double windSpeed;          // Tốc độ gió (m/s)
  final int windDegree;            // Hướng gió (độ)
  final String description;        // Mô tả thời tiết
  final String main;               // Trạng thái chính (Clear, Rain,...)
  final String iconCode;           // Mã icon thời tiết
  final int visibility;            // Tầm nhìn xa (m)
  final int pressure;              // Áp suất khí quyển (hPa)
  final int cloudiness;            // Độ che phủ mây (%)
  final DateTime sunrise;          // Thời gian mặt trời mọc
  final DateTime sunset;           // Thời gian mặt trời lặn
  final DateTime dateTime;         // Thời gian cập nhật
  final double latitude;           // Vĩ độ
  final double longitude;          // Kinh độ
  final double? rainLastHour;      // Lượng mưa 1 giờ qua (mm)

  WeatherModel({
    required this.id,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.description,
    required this.main,
    required this.iconCode,
    required this.visibility,
    required this.pressure,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    this.rainLastHour,
  });

  /// Parse JSON từ API response thành WeatherModel
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      id: json['id'] ?? 0,
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']?['temp'] ?? 0.0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0.0).toDouble(),
      tempMin: (json['main']?['temp_min'] ?? 0.0).toDouble(),
      tempMax: (json['main']?['temp_max'] ?? 0.0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
      windDegree: json['wind']?['deg'] ?? 0,
      description: json['weather']?[0]?['description'] ?? '',
      main: json['weather']?[0]?['main'] ?? '',
      iconCode: json['weather']?[0]?['icon'] ?? '01d',
      visibility: json['visibility'] ?? 0,
      pressure: json['main']?['pressure'] ?? 0,
      cloudiness: json['clouds']?['all'] ?? 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']?['sunrise'] ?? 0) * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']?['sunset'] ?? 0) * 1000,
      ),
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] ?? 0) * 1000,
      ),
      latitude: (json['coord']?['lat'] ?? 0.0).toDouble(),
      longitude: (json['coord']?['lon'] ?? 0.0).toDouble(),
      rainLastHour: json['rain']?['1h']?.toDouble(),
    );
  }

  /// Chuyển WeatherModel thành JSON để lưu cache
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': cityName,
      'sys': {'country': country, 'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000, 'sunset': sunset.millisecondsSinceEpoch ~/ 1000},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {'speed': windSpeed, 'deg': windDegree},
      'weather': [{'description': description, 'main': main, 'icon': iconCode}],
      'visibility': visibility,
      'clouds': {'all': cloudiness},
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'coord': {'lat': latitude, 'lon': longitude},
      if (rainLastHour != null) 'rain': {'1h': rainLastHour},
    };
  }

  /// Kiểm tra có phải ban đêm không (dựa trên giờ)
  bool get isNight {
    final now = DateTime.now();
    return now.isBefore(sunrise) || now.isAfter(sunset);
  }

  /// Nhiệt độ làm tròn
  int get tempRounded => temperature.round();

  @override
  String toString() => 'WeatherModel($cityName, ${tempRounded}°C, $main)';
}