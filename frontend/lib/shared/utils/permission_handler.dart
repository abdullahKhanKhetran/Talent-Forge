import 'package:permission_handler/permission_handler.dart';

/// Permission handler utility for managing app permissions.
class PermissionHelper {
  PermissionHelper._();

  /// Request location permission for GPS attendance.
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Check if location permission is granted.
  static Future<bool> hasLocationPermission() async {
    return await Permission.location.isGranted;
  }

  /// Request camera permission for face attendance.
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted.
  static Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  /// Request notification permission.
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Request storage permission for PDF/Excel downloads.
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Open app settings if permission is permanently denied.
  static Future<void> openSettings() async {
    await openAppSettings();
  }

  /// Request all required permissions at once.
  static Future<Map<Permission, PermissionStatus>>
  requestAllPermissions() async {
    return await [
      Permission.location,
      Permission.camera,
      Permission.notification,
    ].request();
  }
}
