import '../../domain/entities/leave_request.dart';
import 'leave_type_model.dart';
import '../../../Auth/data/models/user_model.dart';

class LeaveRequestModel extends LeaveRequest {
  const LeaveRequestModel({
    required super.id,
    required super.userId,
    required super.leaveType,
    required super.startDate,
    required super.endDate,
    required super.totalDays,
    required super.reason,
    required super.status,
    super.rejectionReason,
    super.adminRemarks,
    super.user,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json['id'],
      userId: json['user_id'],
      leaveType: LeaveTypeModel.fromJson(json['leave_type']),
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalDays: double.parse(json['total_days'].toString()),
      reason: json['reason'],
      status: json['status'],
      rejectionReason: json['rejection_reason'],
      adminRemarks: json['admin_remarks'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
