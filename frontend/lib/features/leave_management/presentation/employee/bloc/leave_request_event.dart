part of 'leave_request_bloc.dart';

abstract class LeaveRequestEvent extends Equatable {
  const LeaveRequestEvent();

  @override
  List<Object> get props => [];
}

class LoadLeaveDashboard extends LeaveRequestEvent {}

class SubmitLeaveRequest extends LeaveRequestEvent {
  final int leaveTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;

  const SubmitLeaveRequest({
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  @override
  List<Object> get props => [leaveTypeId, startDate, endDate, reason];
}
