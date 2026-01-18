import 'dart:io';
import 'package:flutter/foundation.dart';

/// API Constants for TalentForge Application
/// Points exclusively to the .NET Gateway (IngestorService).
class ApiConstants {
  ApiConstants._();

  // --- Config ---
  static const bool useGateway = false; // Set to true to use .NET Gateway

  // --- Base URL (Corrected for Local Development) ---
  static String get baseUrl {
    final port = useGateway ? '5046' : '8000';
    if (kIsWeb) return 'http://localhost:$port';
    if (Platform.isAndroid) return 'http://10.0.2.2:$port'; // Android Emulator
    return 'http://localhost:$port'; // iOS/Desktop
  }

  // --- API Versioning ---
  // If useGateway is true, we need '/api/v1' (gateway prefix)
  // If useGateway is false, we use '/api' (laravel default prefix)
  static String get apiVersion => useGateway ? '/api/v1' : '/api';

  // --- Endpoints ---
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Attendance
  static const String checkIn = '/attendance/check-in';
  static const String checkOut = '/attendance/check-out';
  static const String attendanceHistory = '/attendance/history';
  static const String liveAttendance = '/attendance/live'; // WebSocket/SignalR

  // Leave
  static const String leaveRequest = '/leaves'; // POST
  static const String myLeaves = '/leaves/my-requests'; // GET
  static const String leaveBalance = '/leave-balances'; // GET
  static const String leaveTypes = '/leave-types'; // GET
  static const String pendingLeaves = '/admin/leaves/pending'; // GET
  static const String approveLeave =
      '/admin/leaves/approve'; // POST (needs ID injection)
  static const String rejectLeave =
      '/admin/leaves/reject'; // POST (needs ID injection)

  // Payroll (Admin)
  static const String payrollList = '/payroll';
  static const String payslip = '/payroll/payslip';

  // AI Features
  static const String anomalyAlerts = '/ai/anomalies';
  static const String chatbotMessage = '/ai/chatbot';
  static const String performanceInsights = '/ai/performance';

  // Employees (Admin)
  static const String employees = '/employees';
}
