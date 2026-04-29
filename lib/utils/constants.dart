// lib/utils/constants.dart
// Các hằng số dùng chung trong toàn bộ app

import 'package:flutter/material.dart';

class AppColors {
  // ---- Gradient theo thời tiết ----

  // Trời nắng / quang đãng
  static const List<Color> sunnyGradient = [
    Color(0xFFFDB813),
    Color(0xFF87CEEB),
  ];

  // Trời mưa
  static const List<Color> rainyGradient = [
    Color(0xFF4A5568),
    Color(0xFF718096),
  ];

  // Trời có mây
  static const List<Color> cloudyGradient = [
    Color(0xFFA0AEC0),
    Color(0xFFCBD5E0),
  ];

  // Ban đêm
  static const List<Color> nightGradient = [
    Color(0xFF2D3748),
    Color(0xFF1A202C),
  ];

  // Sấm sét / bão
  static const List<Color> stormGradient = [
    Color(0xFF2C3E50),
    Color(0xFF4A5568),
  ];

  // Tuyết
  static const List<Color> snowGradient = [
    Color(0xFFBEE3F8),
    Color(0xFFEBF8FF),
  ];

  // Sương mù
  static const List<Color> fogGradient = [
    Color(0xFFCBD5E0),
    Color(0xFFE2E8F0),
  ];

  // ---- Màu chung ----
  static const Color white = Colors.white;
  static const Color cardBackground = Color(0x33FFFFFF); // Trắng 20%
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xCCFFFFFF); // Trắng 80%
}

class AppStyles {
  static const double screenPadding = 20.0;
  static const double cardBorderRadius = 20.0;
  static const double cardElevation = 4.0;

  // Text styles
  static const TextStyle temperatureLarge = TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.w200,
    color: AppColors.white,
    height: 1.0,
  );

  static const TextStyle temperatureMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w300,
    color: AppColors.white,
  );

  static const TextStyle cityName = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle weatherDescription = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
}

/// Lấy gradient theo trạng thái thời tiết
List<Color> getWeatherGradient({
  required String weatherMain,
  required bool isNight,
}) {
  if (isNight) return AppColors.nightGradient;

  switch (weatherMain.toLowerCase()) {
    case 'clear':
      return AppColors.sunnyGradient;
    case 'clouds':
      return AppColors.cloudyGradient;
    case 'rain':
    case 'drizzle':
      return AppColors.rainyGradient;
    case 'thunderstorm':
      return AppColors.stormGradient;
    case 'snow':
      return AppColors.snowGradient;
    case 'mist':
    case 'fog':
    case 'haze':
    case 'smoke':
    case 'dust':
    case 'sand':
    case 'ash':
    case 'squall':
    case 'tornado':
      return AppColors.fogGradient;
    default:
      return AppColors.cloudyGradient;
  }
}