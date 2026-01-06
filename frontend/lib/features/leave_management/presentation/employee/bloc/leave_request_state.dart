part of 'leave_request_bloc.dart';

abstract class LeaveRequestState extends Equatable {
  const LeaveRequestState();

  @override
  List<Object?> get props => [];
}

class LeaveRequestInitial extends LeaveRequestState {}

class LeaveRequestLoading extends LeaveRequestState {}

class LeaveDashboardLoaded extends LeaveRequestState {
  final List<LeaveType> leaveTypes;
  final List<LeaveBalance> balances;
  final List<LeaveRequest> requestHistory;

  const LeaveDashboardLoaded({
    required this.leaveTypes,
    required this.balances,
    required this.requestHistory,
  });

  @override
  List<Object?> get props => [leaveTypes, balances, requestHistory];
}

class LeaveRequestSuccess extends LeaveRequestState {
  final String message;
  const LeaveRequestSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class LeaveRequestFailure extends LeaveRequestState {
  final String message;

  const LeaveRequestFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
