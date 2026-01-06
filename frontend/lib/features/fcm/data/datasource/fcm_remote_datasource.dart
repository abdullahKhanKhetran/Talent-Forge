import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/device_model.dart';

abstract interface class FCMRemoteDataSource {
  Future<String> getDeviceToken();
  Future<DeviceModel> upsertDeviceInfo(DeviceModel model);
}

class FCMRemoteDataSourceImpl implements FCMRemoteDataSource {
  final DioClient dioClient;
  final FirebaseMessaging firebaseMessaging;

  FCMRemoteDataSourceImpl({
    required this.dioClient,
    required this.firebaseMessaging,
  });

  @override
  Future<String> getDeviceToken() async {
    try {
      final token = await firebaseMessaging.getToken();
      if (token == null) {
        throw ServerException(message: "Failed to get FCM token");
      }
      return token;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DeviceModel> upsertDeviceInfo(DeviceModel model) async {
    try {
      // Laravel endpoint expected: POST /api/user-devices
      final response = await dioClient.post(
        '/user-devices',
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeviceModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to sync device info',
        );
      }
    } catch (e) {
      // We might want to just log this instead of crashing app flow if sync fails
      throw ServerException(message: e.toString());
    }
  }
}
