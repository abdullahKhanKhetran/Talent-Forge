/// API Constants for TalentForge Application
/// Points exclusively to the .NET Gateway (IngestorService).
class ApiConstants {
  ApiConstants._();

  // --- Base URL (Update for Production) ---
  static const String baseUrl = 'http://localhost:5000'; // .NET Gateway

  // --- API Versioning ---
  static const String apiVersion = '/api/v1';

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
