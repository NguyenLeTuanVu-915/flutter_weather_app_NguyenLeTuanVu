// lib/widgets/weather_error_widget.dart
// Widget hiển thị khi có lỗi (mất mạng, API lỗi, city không tìm thấy...)

import 'package:flutter/material.dart';

class WeatherErrorWidget extends StatelessWidget {
  final String message;          // Thông báo lỗi
  final VoidCallback? onRetry;   // Callback khi nhấn Thử lại
  final VoidCallback? onSearch;  // Callback khi nhấn Tìm kiếm

  const WeatherErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định icon và tiêu đề dựa trên loại lỗi
    String errorIcon;
    String errorTitle;

    if (message.contains('internet') || message.contains('kết nối') ||
        message.contains('network')) {
      errorIcon = '📡';
      errorTitle = 'Mất kết nối internet';
    } else if (message.contains('thành phố') || message.contains('city') ||
        message.contains('404')) {
      errorIcon = '🔍';
      errorTitle = 'Không tìm thấy địa điểm';
    } else if (message.contains('API') || message.contains('key') ||
        message.contains('401')) {
      errorIcon = '🔑';
      errorTitle = 'Lỗi xác thực API';
    } else if (message.contains('vị trí') || message.contains('GPS') ||
        message.contains('location')) {
      errorIcon = '📍';
      errorTitle = 'Không thể lấy vị trí';
    } else {
      errorIcon = '⚠️';
      errorTitle = 'Đã xảy ra lỗi';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Text(errorIcon, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),

            // Error title
            Text(
              errorTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Nút Thử lại
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

            if (onRetry != null && onSearch != null)
              const SizedBox(height: 12),

            // Nút Tìm kiếm
            if (onSearch != null)
              OutlinedButton.icon(
                onPressed: onSearch,
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  'Tìm thành phố khác',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}