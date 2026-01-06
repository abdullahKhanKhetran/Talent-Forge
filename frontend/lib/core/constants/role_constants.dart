/// Role Constants for TalentForge RBAC.
class RoleConstants {
  RoleConstants._();

  static const String admin = 'admin';
  static const String employee = 'employee';
  static const String manager = 'manager'; // Future

  /// Check if a role string represents an admin.
  static bool isAdmin(String? role) => role?.toLowerCase() == admin;

  /// Check if a role string represents an employee.
  static bool isEmployee(String? role) => role?.toLowerCase() == employee;
}
