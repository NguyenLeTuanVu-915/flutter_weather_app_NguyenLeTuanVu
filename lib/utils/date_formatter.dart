import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDayMonth(DateTime date) {
    final weekday = _getVietnameseWeekday(date.weekday);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$weekday, $day/$month';
  }

  static String formatHour(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatFullDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatRelativeDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(date.year, date.month, date.day);

    final difference = targetDay.difference(today).inDays;
    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Ngày mai';
    return _getVietnameseWeekday(date.weekday);
  }

  static String _getVietnameseWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Thứ 2';
      case DateTime.tuesday:
        return 'Thứ 3';
      case DateTime.wednesday:
        return 'Thứ 4';
      case DateTime.thursday:
        return 'Thứ 5';
      case DateTime.friday:
        return 'Thứ 6';
      case DateTime.saturday:
        return 'Thứ 7';
      case DateTime.sunday:
        return 'CN';
      default:
        return '';
    }
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}