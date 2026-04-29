// lib/widgets/hourly_forecast_list.dart
// Danh sách dự báo thời tiết theo từng giờ (scroll ngang)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/hourly_weather_model.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyWeatherModel> hourlyList;

  const HourlyForecastList({super.key, required this.hourlyList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('⏱️ Dự báo theo giờ', style: AppStyles.sectionTitle),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = hourlyList[index];
              return _HourlyItem(item: item, isFirst: index == 0);
            },
          ),
        ),
      ],
    );
  }
}

class _HourlyItem extends StatelessWidget {
  final HourlyWeatherModel item;
  final bool isFirst;

  const _HourlyItem({required this.item, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isFirst
            ? Colors.white.withOpacity(0.3) // Highlight giờ đầu
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFirst ? Colors.white : Colors.white24,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Thời gian
          Text(
            isFirst ? 'Ngay\nhiện tại' : DateFormatter.formatHour(item.dateTime),
            style: TextStyle(
              color: isFirst ? Colors.white : Colors.white70,
              fontSize: 11,
              fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),

          // Icon
          CachedNetworkImage(
            imageUrl: ApiConfig.weatherIconUrl(item.iconCode),
            width: 36,
            height: 36,
            placeholder: (_, __) => Text(
              WeatherIcons.getEmoji(item.iconCode),
              style: const TextStyle(fontSize: 24),
            ),
            errorWidget: (_, __, ___) => Text(
              WeatherIcons.getEmoji(item.iconCode),
              style: const TextStyle(fontSize: 24),
            ),
          ),

          // Nhiệt độ
          Text(
            '${item.tempRounded}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Xác suất mưa
          if (item.popPercent > 0.1)
            Text(
              '💧 ${item.popPercent100}%',
              style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 10),
            ),
        ],
      ),
    );
  }
}