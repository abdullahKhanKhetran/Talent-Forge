import '../../domain/entities/leave_balance.dart';
import 'leave_type_model.dart';

class LeaveBalanceModel extends LeaveBalance {
  const LeaveBalanceModel({
    required super.id,
    required super.userId,
    required super.leaveType,
    required super.year,
    required super.totalDays,
    required super.usedDays,
    required super.remainingDays,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      id: json['id'],
      userId: json['user_id'],
      leaveType: LeaveTypeModel.fromJson(json['leave_type']),
      year: json['year'],
      totalDays: double.parse(json['total_days'].toString()),
      usedDays: double.parse(json['used_days'].toString()),
      remainingDays: double.parse(json['remaining_days'].toString()),
    );
  }
}
