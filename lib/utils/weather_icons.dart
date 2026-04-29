// lib/utils/weather_icons.dart
// Mapping từ weather condition → emoji icon

class WeatherIcons {
  /// Trả về emoji tương ứng với mã icon từ API
  static String getEmoji(String iconCode) {
    // iconCode từ API: "01d", "02d", "10n", v.v.
    // Số: loại thời tiết, chữ: d=ngày, n=đêm
    switch (iconCode.substring(0, 2)) {
      case '01': // Trời quang
        return iconCode.endsWith('d') ? '☀️' : '🌙';
      case '02': // Vài đám mây
        return iconCode.endsWith('d') ? '⛅' : '🌙';
      case '03': // Có mây rải rác
        return '🌤️';
      case '04': // Trời nhiều mây
        return '☁️';
      case '09': // Mưa nhỏ
        return '🌧️';
      case '10': // Mưa
        return iconCode.endsWith('d') ? '🌦️' : '🌧️';
      case '11': // Sấm sét
        return '⛈️';
      case '13': // Tuyết
        return '❄️';
      case '50': // Sương mù
        return '🌫️';
      default:
        return '🌡️';
    }
  }

  /// Mô tả tiếng Việt theo weather main
  static String getVietnameseDescription(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return 'Trời quang đãng';
      case 'clouds':
        return 'Có mây';
      case 'rain':
        return 'Mưa';
      case 'drizzle':
        return 'Mưa nhỏ';
      case 'thunderstorm':
        return 'Bão sấm sét';
      case 'snow':
        return 'Tuyết rơi';
      case 'mist':
      case 'fog':
        return 'Sương mù';
      case 'haze':
        return 'Mờ đục';
      default:
        return main;
    }
  }

  /// Icon hướng gió dựa trên độ
  static String getWindDirectionIcon(int degree) {
    if (degree >= 337 || degree < 23) return '↑ N';
    if (degree >= 23 && degree < 68) return '↗ NE';
    if (degree >= 68 && degree < 113) return '→ E';
    if (degree >= 113 && degree < 158) return '↘ SE';
    if (degree >= 158 && degree < 203) return '↓ S';
    if (degree >= 203 && degree < 248) return '↙ SW';
    if (degree >= 248 && degree < 293) return '← W';
    return '↖ NW';
  }
}