import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

abstract interface class DeviceInfoService {
  Future<String> getOrCreateDeviceId();
}

class DeviceInfoServiceImpl implements DeviceInfoService {
  final FlutterSecureStorage secureStorage;
  static const String _deviceIdKey = 'device_id';

  const DeviceInfoServiceImpl({required this.secureStorage});

  @override
  Future<String> getOrCreateDeviceId() async {
    String? deviceId = await secureStorage.read(key: _deviceIdKey);
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await secureStorage.write(key: _deviceIdKey, value: deviceId);
    }
    return deviceId;
  }
}
