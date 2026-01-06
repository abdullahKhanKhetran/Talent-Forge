import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_type.dart';

abstract class LeaveRepository {
  Future<Either<Failure, List<LeaveType>>> getLeaveTypes();
  Future<Either<Failure, List<LeaveBalance>>> getLeaveBalances();
  Future<Either<Failure, List<LeaveRequest>>> getMyLeaveRequests();
  Future<Either<Failure, LeaveRequest>> submitLeaveRequest({
    required int leaveTypeId,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  });

  // Admin
  Future<Either<Failure, List<LeaveRequest>>> getPendingLeaves();
  Future<Either<Failure, LeaveRequest>> approveLeave(int id);
  Future<Either<Failure, LeaveRequest>> rejectLeave(int id, String reason);
}
