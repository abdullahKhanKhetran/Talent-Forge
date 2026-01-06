import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  DeviceModel({
    required super.id,
    required super.userId,
    required super.fcmToken,
    required super.platform,
    required super.deviceInfo,
    required super.lastActive,
    required super.createdAt,
    required super.authStatus,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      userId: json['user_id'],
      fcmToken: json['fcm_token'],
      platform: json['platform'],
      deviceInfo: json['device_info'],
      lastActive: DateTime.parse(json['last_active']),
      createdAt: DateTime.parse(json['created_at']),
      authStatus: json['auth_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "fcm_token": fcmToken,
      "auth_status": authStatus,
      "platform": platform,
      "device_info": deviceInfo,
      "last_active": lastActive.toIso8601String(),
      "created_at": createdAt.toIso8601String(),
    };
  }
}
