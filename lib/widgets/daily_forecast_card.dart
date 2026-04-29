// lib/widgets/daily_forecast_card.dart
// Card hiển thị dự báo thời tiết từng ngày

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/forecast_model.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyForecastModel forecast;

  const DailyForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          // Tên ngày
          SizedBox(
            width: 80,
            child: Text(
              DateFormatter.formatRelativeDay(forecast.date),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Icon thời tiết
          CachedNetworkImage(
            imageUrl: ApiConfig.weatherIconUrl(forecast.iconCode),
            width: 40,
            height: 40,
            placeholder: (_, __) => Text(
              WeatherIcons.getEmoji(forecast.iconCode),
              style: const TextStyle(fontSize: 28),
            ),
            errorWidget: (_, __, ___) => Text(
              WeatherIcons.getEmoji(forecast.iconCode),
              style: const TextStyle(fontSize: 28),
            ),
          ),

          // Xác suất mưa
          const SizedBox(width: 8),
          if (forecast.popPercent > 0.1)
            Text(
              '💧 ${forecast.popPercent100}%',
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 12,
              ),
            ),

          const Spacer(),

          // Nhiệt độ min - max
          Row(
            children: [
              Text(
                '${forecast.tempMinRounded}°',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              // Thanh nhiệt độ
              _TempBar(
                min: forecast.tempMinRounded,
                max: forecast.tempMaxRounded,
              ),
              const SizedBox(width: 4),
              Text(
                '${forecast.tempMaxRounded}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Thanh gradient thể hiện khoảng nhiệt độ
class _TempBar extends StatelessWidget {
  final int min;
  final int max;

  const _TempBar({required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 6,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.lightBlue, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}