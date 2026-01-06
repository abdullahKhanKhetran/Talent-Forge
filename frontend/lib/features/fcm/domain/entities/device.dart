class Device {
  final String id;
  final String userId;
  final String authStatus;
  final String fcmToken;
  final String platform;
  final Map<String, dynamic> deviceInfo;
  final DateTime lastActive;
  final DateTime createdAt;
  const Device({
    required this.id,
    required this.userId,
    required this.authStatus,
    required this.fcmToken,
    required this.platform,
    required this.deviceInfo,
    required this.lastActive,
    required this.createdAt,
  });
}
