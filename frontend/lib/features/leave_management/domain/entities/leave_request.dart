import 'package:equatable/equatable.dart';
import 'leave_type.dart';
import '../../../../core/common/entities/user.dart';

class LeaveRequest extends Equatable {
  final int id;
  final int userId;
  final LeaveType leaveType;
  final String startDate;
  final String endDate;
  final double totalDays;
  final String reason;
  final String status; // pending, approved, rejected
  final String? rejectionReason;
  final String? adminRemarks;
  final User? user;

  const LeaveRequest({
    required this.id,
    required this.userId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    this.rejectionReason,
    this.adminRemarks,
    this.user,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  @override
  List<Object?> get props => [
    id,
    userId,
    leaveType,
    startDate,
    endDate,
    totalDays,
    reason,
    status,
    rejectionReason,
    adminRemarks,
    user,
  ];
}
