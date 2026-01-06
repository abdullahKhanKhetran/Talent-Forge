import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_type.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/leave_remote_datasource.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LeaveRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LeaveType>>> getLeaveTypes() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getLeaveTypes();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveBalance>>> getLeaveBalances() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getLeaveBalances();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveRequest>>> getMyLeaveRequests() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyLeaveRequests();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> submitLeaveRequest({
    required int leaveTypeId,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data = {
          'leave_type_id': leaveTypeId,
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
          'reason': reason,
        };
        final result = await remoteDataSource.submitLeaveRequest(data);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<LeaveRequest>>> getPendingLeaves() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPendingLeaves();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> approveLeave(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.approveLeave(id);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> rejectLeave(
    int id,
    String reason,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.rejectLeave(id, reason);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
