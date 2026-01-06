import 'dart:convert';

/// JWT Decoder utility for extracting claims from JWT tokens.
class JwtDecoder {
  JwtDecoder._();

  /// Decode a JWT token and return the payload as a Map.
  static Map<String, dynamic>? decode(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Check if a JWT token is expired.
  static bool isExpired(String token) {
    final payload = decode(token);
    if (payload == null) return true;

    final exp = payload['exp'] as int?;
    if (exp == null) return true;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryDate);
  }

  /// Get the expiry date of a JWT token.
  static DateTime? getExpiryDate(String token) {
    final payload = decode(token);
    if (payload == null) return null;

    final exp = payload['exp'] as int?;
    if (exp == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }

  /// Get the user ID from a JWT token.
  static String? getUserId(String token) {
    final payload = decode(token);
    return payload?['sub'] as String?;
  }

  /// Get the user role from a JWT token.
  static String? getRole(String token) {
    final payload = decode(token);
    return payload?['role'] as String?;
  }
}
