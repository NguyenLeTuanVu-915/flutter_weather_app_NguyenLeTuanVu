// lib/screens/settings_screen.dart
// Màn hình cài đặt

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.all(AppStyles.screenPadding),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Cài đặt',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Consumer<WeatherProvider>(
                  builder: (context, provider, _) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.screenPadding,
                      ),
                      children: [
                        // ---- Đơn vị nhiệt độ ----
                        _sectionHeader('🌡️ Đơn vị nhiệt độ'),
                        const SizedBox(height: 8),
                        _buildUnitToggle(context, provider),
                        const SizedBox(height: 24),

                        // ---- Thành phố yêu thích ----
                        _sectionHeader('❤️ Thành phố yêu thích (${provider.favorites.length}/5)'),
                        const SizedBox(height: 8),
                        if (provider.favorites.isEmpty)
                          _buildEmptyCard('Chưa có thành phố yêu thích')
                        else
                          ...provider.favorites.map(
                                (city) => _buildFavoriteItem(context, provider, city),
                          ),
                        const SizedBox(height: 24),

                        // ---- Thông tin app ----
                        _sectionHeader('ℹ️ Thông tin'),
                        const SizedBox(height: 8),
                        _buildInfoCard('Phiên bản', '1.0.0'),
                        _buildInfoCard('API', 'OpenWeatherMap'),
                        _buildInfoCard('Framework', 'Flutter'),
                        const SizedBox(height: 24),

                        // ---- Xóa cache ----
                        _buildClearCacheButton(context, provider),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildUnitToggle(BuildContext context, WeatherProvider provider) {
    final isCelsius = provider.temperatureUnit == 'metric';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Đơn vị nhiệt độ',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Toggle Celsius / Fahrenheit
          Row(
            children: [
              _unitButton(
                label: '°C',
                isSelected: isCelsius,
                onTap: () => provider.setTemperatureUnit('metric'),
              ),
              const SizedBox(width: 8),
              _unitButton(
                label: '°F',
                isSelected: !isCelsius,
                onTap: () => provider.setTemperatureUnit('imperial'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _unitButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.white : Colors.white54),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.white54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(
      BuildContext context,
      WeatherProvider provider,
      String city,
      ) {
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
          const Icon(Icons.location_on, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(city, style: const TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white54, size: 20),
            onPressed: () {
              provider.removeFavorite(city);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xóa $city')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildClearCacheButton(BuildContext context, WeatherProvider provider) {
    return ElevatedButton.icon(
      onPressed: () async {
        // Hiện dialog xác nhận
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color(0xFF2C3E50),
            title: const Text('Xóa cache', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Bạn có chắc muốn xóa dữ liệu cache không?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa'),
              ),
            ],
          ),
        );

        if (confirm == true && context.mounted) {
          // TODO: Gọi clearAll từ StorageService
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa cache thành công')),
          );
        }
      },
      icon: const Icon(Icons.delete_sweep),
      label: const Text('Xóa cache'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}