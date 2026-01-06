import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/fcm_repository.dart';
import '../entities/device.dart';

class UpsertDevice implements UseCase<Device, UpsertDeviceParams> {
  final FCMRepository repository;

  UpsertDevice({required this.repository});

  @override
  Future<Either<Failure, Device>> call(UpsertDeviceParams params) {
    return repository.upsertDeviceInfo(params.userId, params.authStatus);
  }
}

class UpsertDeviceParams {
  final String userId;
  final String? authStatus;
  UpsertDeviceParams({required this.userId, this.authStatus});
}
