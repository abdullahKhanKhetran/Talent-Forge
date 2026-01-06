import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/device_info_service.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/fcm_repository.dart';
import '../datasource/fcm_remote_datasource.dart';
import '../models/device_model.dart';

class FcmRepositoryImpl implements FCMRepository {
  final FCMRemoteDataSource remote;
  final DeviceInfoService deviceInfoService;

  const FcmRepositoryImpl({
    required this.remote,
    required this.deviceInfoService,
  });

  @override
  Future<Either<Failure, Device>> upsertDeviceInfo(
    String userId,
    String? authStatus,
  ) async {
    try {
      final token = await remote.getDeviceToken();
      final deviceId = await deviceInfoService.getOrCreateDeviceId();
      final deviceModel = DeviceModel(
        id: deviceId,
        userId: userId,
        fcmToken: token,
        authStatus: authStatus ?? '',
        platform: _getPlatform(),
        deviceInfo: _getDeviceInfo(),
        lastActive: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final res = await remote.upsertDeviceInfo(deviceModel);
      return right(res);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  // Helpers
  String _getPlatform() {
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    return "web";
  }

  Map<String, dynamic> _getDeviceInfo() {
    return {
      "os": Platform.operatingSystem,
      "os_version": Platform.operatingSystemVersion,
    };
  }
}
