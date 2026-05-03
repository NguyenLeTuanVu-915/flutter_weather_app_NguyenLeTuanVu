class WeatherIcons {
  static String getEmoji(String iconCode) {
    switch (iconCode.substring(0, 2)) {
      case '01':
        return iconCode.endsWith('d') ? '☀️' : '🌙';
      case '02':
        return iconCode.endsWith('d') ? '⛅' : '🌙';
      case '03':
        return '🌤️';
      case '04':
        return '☁️';
      case '09':
        return '🌧️';
      case '10':
        return iconCode.endsWith('d') ? '🌦️' : '🌧️';
      case '11':
        return '⛈️';
      case '13':
        return '❄️';
      case '50':
        return '🌫️';
      default:
        return '🌡️';
    }
  }

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