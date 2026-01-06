/// App Constants for TalentForge Application.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'TalentForge';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String fcmTokenKey = 'fcm_token';
  static const String themeKey = 'theme_mode';

  // Pagination
  static const int defaultPageSize = 20;

  // Timeouts (in seconds)
  static const int connectionTimeout = 15;
  static const int receiveTimeout = 15;

  // Attendance
  static const int checkInRadiusMeters = 100; // GPS fence radius
  static const int maxLateMinutes = 15; // Minutes before marked as late

  // Leave
  static const int maxLeaveRequestDays = 30;

  // AI Risk Scores
  static const double lowRiskThreshold = 0.3;
  static const double mediumRiskThreshold = 0.6;
  static const double highRiskThreshold = 0.8;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';
}
