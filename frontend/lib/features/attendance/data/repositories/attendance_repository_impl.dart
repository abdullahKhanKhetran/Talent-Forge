import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AttendanceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AttendanceRecord>> checkIn({
    required double latitude,
    required double longitude,
    required String notes,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.checkIn(
          latitude,
          longitude,
          notes,
        );
        return Right(remoteData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      // TODO: Implement Logic for Offline Sync
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AttendanceRecord>> checkOut({
    required double latitude,
    required double longitude,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.checkOut(latitude, longitude);
        return Right(remoteData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceHistory() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getAttendanceHistory();
        return Right(remoteData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecord>>> getLiveAttendance() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getLiveAttendance();
        return Right(remoteData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
