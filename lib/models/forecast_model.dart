// lib/models/forecast_model.dart
// Model cho dự báo thời tiết theo ngày (gộp từ API /forecast)

import 'hourly_weather_model.dart';

class DailyForecastModel {
  final DateTime date;              // Ngày dự báo
  final double tempMax;             // Nhiệt độ cao nhất trong ngày
  final double tempMin;             // Nhiệt độ thấp nhất trong ngày
  final String description;         // Mô tả thời tiết
  final String main;                // Trạng thái chính
  final String iconCode;            // Mã icon
  final int humidity;               // Độ ẩm trung bình
  final double windSpeed;           // Tốc độ gió trung bình
  final double popPercent;          // Xác suất mưa tối đa trong ngày
  final List<HourlyWeatherModel> hourlyList; // Dự báo theo giờ trong ngày

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

  /// Tạo DailyForecastModel từ danh sách HourlyWeatherModel trong cùng một ngày
  factory DailyForecastModel.fromHourlyList(
      DateTime date,
      List<HourlyWeatherModel> hourlyList,
      ) {
    // Tìm nhiệt độ cao/thấp nhất trong ngày
    final temps = hourlyList.map((h) => h.temperature).toList();
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final minTemp = temps.reduce((a, b) => a < b ? a : b);

    // Lấy thời tiết của buổi trưa (12h) hoặc của phần tử giữa
    final midday = hourlyList.firstWhere(
          (h) => h.dateTime.hour >= 12 && h.dateTime.hour <= 15,
      orElse: () => hourlyList[hourlyList.length ~/ 2],
    );

    // Tính trung bình độ ẩm
    final avgHumidity =
    (hourlyList.map((h) => h.humidity).reduce((a, b) => a + b) /
        hourlyList.length)
        .round();

    // Tính trung bình tốc độ gió
    final avgWind =
        hourlyList.map((h) => h.windSpeed).reduce((a, b) => a + b) /
            hourlyList.length;

    // Lấy xác suất mưa cao nhất
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