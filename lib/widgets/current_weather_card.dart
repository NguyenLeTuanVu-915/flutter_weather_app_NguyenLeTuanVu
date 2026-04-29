// lib/widgets/current_weather_card.dart
// Card hiển thị thời tiết hiện tại (nhiệt độ lớn, icon, mô tả)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';
import 'weather_detail_item.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isFromCache;
  // FIX BUG 2: Nhận ký hiệu đơn vị từ bên ngoài (°C hoặc °F)
  final String tempUnit;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    this.isFromCache = false,
    this.tempUnit = '°C', // Mặc định Celsius
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMainSection(),
        const SizedBox(height: 24),
        _buildTempRangeRow(),
        const SizedBox(height: 24),
        _buildDetailsGrid(),
        const SizedBox(height: 12),
        _buildSunriseSunset(),
        if (isFromCache) ...[
          const SizedBox(height: 12),
          _buildCacheBanner(),
        ],
      ],
    );
  }

  Widget _buildMainSection() {
    return Column(
      children: [
        // Icon thời tiết từ API
        CachedNetworkImage(
          imageUrl: ApiConfig.weatherIconUrl(weather.iconCode),
          width: 120,
          height: 120,
          placeholder: (context, url) => Text(
            WeatherIcons.getEmoji(weather.iconCode),
            style: const TextStyle(fontSize: 80),
          ),
          errorWidget: (context, url, error) => Text(
            WeatherIcons.getEmoji(weather.iconCode),
            style: const TextStyle(fontSize: 80),
          ),
        ),

        // FIX BUG 2: Dùng tempUnit thay vì hardcode '°C'
        Text(
          '${weather.tempRounded}$tempUnit',
          style: AppStyles.temperatureLarge,
        ),

        Text(
          '${weather.cityName}, ${weather.country}',
          style: AppStyles.cityName,
        ),

        const SizedBox(height: 4),

        Text(
          weather.description.toUpperCase(),
          style: AppStyles.weatherDescription,
        ),

        const SizedBox(height: 4),

        Text(
          'Cập nhật: ${DateFormatter.formatFullDateTime(weather.dateTime)}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTempRangeRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // FIX BUG 2: Dùng tempUnit cho tất cả hiển thị nhiệt độ
          _tempItem('🌡️ Cảm giác', '${weather.feelsLike.round()}$tempUnit'),
          _divider(),
          _tempItem('⬆️ Cao nhất', '${weather.tempMax.round()}$tempUnit'),
          _divider(),
          _tempItem('⬇️ Thấp nhất', '${weather.tempMin.round()}$tempUnit'),
        ],
      ),
    );
  }

  Widget _tempItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 30, color: Colors.white24);
  }

  Widget _buildDetailsGrid() {
    final windDir = WeatherIcons.getWindDirectionIcon(weather.windDegree);
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.0,
      children: [
        WeatherDetailItem(
          icon: '💧',
          label: 'Độ ẩm',
          value: '${weather.humidity}%',
        ),
        WeatherDetailItem(
          icon: '💨',
          label: 'Tốc độ gió',
          value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
        ),
        WeatherDetailItem(
          icon: '🧭',
          label: 'Hướng gió',
          value: windDir,
        ),
        WeatherDetailItem(
          icon: '👁️',
          label: 'Tầm nhìn',
          value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
        ),
        WeatherDetailItem(
          icon: '🌫️',
          label: 'Áp suất',
          value: '${weather.pressure} hPa',
        ),
        WeatherDetailItem(
          icon: '☁️',
          label: 'Mây che',
          value: '${weather.cloudiness}%',
        ),
      ],
    );
  }

  Widget _buildSunriseSunset() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _sunItem('🌅', 'Mặt trời mọc', DateFormatter.formatTime(weather.sunrise)),
          _divider(),
          _sunItem('🌇', 'Mặt trời lặn', DateFormatter.formatTime(weather.sunset)),
        ],
      ),
    );
  }

  Widget _sunItem(String emoji, String label, String time) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        Text(
          time,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCacheBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.offline_bolt, color: Colors.orange, size: 16),
          SizedBox(width: 6),
          Text(
            'Đang hiển thị dữ liệu lưu trữ (Offline)',
            style: TextStyle(color: Colors.orange, fontSize: 12),
          ),
        ],
      ),
    );
  }
}