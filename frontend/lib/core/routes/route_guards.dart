import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/jwt_decoder.dart';
import '../../init_dependencies.dart';

/// Route guard to check if user is authenticated.
Future<String?> authGuard(BuildContext context, GoRouterState state) async {
  final secureStorage = sl<FlutterSecureStorage>();
  final token = await secureStorage.read(key: 'access_token');

  if (token == null || JwtDecoder.isExpired(token)) {
    return '/login';
  }

  return null; // Allow access
}

/// Route guard to check if user is admin.
Future<String?> adminGuard(BuildContext context, GoRouterState state) async {
  final secureStorage = sl<FlutterSecureStorage>();
  final token = await secureStorage.read(key: 'access_token');

  if (token == null || JwtDecoder.isExpired(token)) {
    return '/login';
  }

  final role = JwtDecoder.getRole(token);
  if (role != 'admin') {
    return '/employee'; // Redirect non-admins to employee dashboard
  }

  return null; // Allow access
}

/// Route guard to check if user is employee.
Future<String?> employeeGuard(BuildContext context, GoRouterState state) async {
  final secureStorage = sl<FlutterSecureStorage>();
  final token = await secureStorage.read(key: 'access_token');

  if (token == null || JwtDecoder.isExpired(token)) {
    return '/login';
  }

  return null; // Employees can access employee routes
}

/// Redirect authenticated users away from login page.
Future<String?> guestGuard(BuildContext context, GoRouterState state) async {
  final secureStorage = sl<FlutterSecureStorage>();
  final token = await secureStorage.read(key: 'access_token');

  if (token != null && !JwtDecoder.isExpired(token)) {
    final role = JwtDecoder.getRole(token);
    return role == 'admin' ? '/admin' : '/employee';
  }

  return null; // Allow access to login
}
