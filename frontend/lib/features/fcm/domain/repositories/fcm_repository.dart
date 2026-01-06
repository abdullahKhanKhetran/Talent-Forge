import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/device.dart';

abstract interface class FCMRepository {
  Future<Either<Failure, Device>> upsertDeviceInfo(
    String userId,
    String? authStatus,
  );
}
