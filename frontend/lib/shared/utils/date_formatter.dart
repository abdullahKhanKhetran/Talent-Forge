import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';

/// Date formatter utility for consistent date/time formatting.
class DateFormatter {
  DateFormatter._();

  /// Format date as yyyy-MM-dd
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  /// Format time as HH:mm
  static String formatTime(DateTime time) {
    return DateFormat(AppConstants.timeFormat).format(time);
  }

  /// Format datetime as yyyy-MM-dd HH:mm
  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }

  /// Format for display as "Jan 01, 2024"
  static String formatDisplayDate(DateTime date) {
    return DateFormat(AppConstants.displayDateFormat).format(date);
  }

  /// Format for display as "10:30 AM"
  static String formatDisplayTime(DateTime time) {
    return DateFormat(AppConstants.displayTimeFormat).format(time);
  }

  /// Get relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDisplayDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Parse date string to DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat(AppConstants.dateFormat).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get day of week name
  static String getDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Get month name
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }
}
