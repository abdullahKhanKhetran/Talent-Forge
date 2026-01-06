import 'package:equatable/equatable.dart';
import 'leave_type.dart';

class LeaveBalance extends Equatable {
  final int id;
  final int userId;
  final LeaveType leaveType;
  final int year;
  final double totalDays;
  final double usedDays;
  final double remainingDays;

  const LeaveBalance({
    required this.id,
    required this.userId,
    required this.leaveType,
    required this.year,
    required this.totalDays,
    required this.usedDays,
    required this.remainingDays,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    leaveType,
    year,
    totalDays,
    usedDays,
    remainingDays,
  ];
}
