part of 'leave_approval_bloc.dart';

abstract class LeaveApprovalState extends Equatable {
  const LeaveApprovalState();

  @override
  List<Object?> get props => [];
}

class LeaveApprovalInitial extends LeaveApprovalState {}

class LeaveApprovalLoading extends LeaveApprovalState {}

class LeaveApprovalLoaded extends LeaveApprovalState {
  final List<LeaveRequest> pendingLeaves;
  const LeaveApprovalLoaded({required this.pendingLeaves});

  @override
  List<Object?> get props => [pendingLeaves];
}

class LeaveApprovalFailure extends LeaveApprovalState {
  final String message;
  const LeaveApprovalFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
