import 'package:flutter/material.dart';

/// App Colors for TalentForge.
class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFF2563EB); // Blue
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Secondary / Accent
  static const Color accent = Color(0xFF10B981); // Emerald Green
  static const Color secondary = accent;

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Risk Score Colors (AI Features)
  static const Color riskLow = Color(0xFF22C55E);
  static const Color riskMedium = Color(0xFFF59E0B);
  static const Color riskHigh = Color(0xFFEF4444);

  // Neutral
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
}
