import 'hourly_weather_model.dart';

class DailyForecastModel {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String description;
  final String main;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final double popPercent;
  final List<HourlyWeatherModel> hourlyList;

  DailyForecastModel({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.description,
    required this.main,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.popPercent,
    required this.hourlyList,
  });

  factory DailyForecastModel.fromHourlyList(
      DateTime date,
      List<HourlyWeatherModel> hourlyList,
      ) {
    final temps = hourlyList.map((h) => h.temperature).toList();
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final minTemp = temps.reduce((a, b) => a < b ? a : b);

    final midday = hourlyList.firstWhere(
          (h) => h.dateTime.hour >= 12 && h.dateTime.hour <= 15,
      orElse: () => hourlyList[hourlyList.length ~/ 2],
    );

    final avgHumidity =
    (hourlyList.map((h) => h.humidity).reduce((a, b) => a + b) /
        hourlyList.length)
        .round();

    final avgWind =
        hourlyList.map((h) => h.windSpeed).reduce((a, b) => a + b) /
            hourlyList.length;

    final maxPop = hourlyList
        .map((h) => h.popPercent)
        .reduce((a, b) => a > b ? a : b);

    return DailyForecastModel(
      date: date,
      tempMax: maxTemp,
      tempMin: minTemp,
      description: midday.description,
      main: midday.main,
      iconCode: midday.iconCode,
      humidity: avgHumidity,
      windSpeed: avgWind,
      popPercent: maxPop,
      hourlyList: hourlyList,
    );
  }

  int get tempMaxRounded => tempMax.round();
  int get tempMinRounded => tempMin.round();
  int get popPercent100 => (popPercent * 100).round();
}