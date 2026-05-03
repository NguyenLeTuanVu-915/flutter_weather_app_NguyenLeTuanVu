class WeatherModel {
  final int id;
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final String description;
  final String main;
  final String iconCode;
  final int visibility;
  final int pressure;
  final int cloudiness;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final double? rainLastHour;

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

  bool get isNight {
    final now = DateTime.now();
    return now.isBefore(sunrise) || now.isAfter(sunset);
  }

  int get tempRounded => temperature.round();

  @override
  String toString() => 'WeatherModel($cityName, ${tempRounded}°C, $main)';
}