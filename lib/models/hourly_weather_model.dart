class HourlyWeatherModel {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final String description;
  final String main;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final int cloudiness;
  final double? rainVolume;
  final double popPercent;

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