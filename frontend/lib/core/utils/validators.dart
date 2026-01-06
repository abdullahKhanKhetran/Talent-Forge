/// Validators utility for form validation.
class Validators {
  Validators._();

  /// Validate email format.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password (min 8 chars).
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  /// Validate confirm password.
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate required field.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate phone number.
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validate employee code.
  static String? employeeCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Employee code is required';
    }
    if (value.length < 3) {
      return 'Employee code must be at least 3 characters';
    }
    return null;
  }
}
