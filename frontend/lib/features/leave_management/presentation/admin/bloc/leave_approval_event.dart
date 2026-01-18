part of 'leave_approval_bloc.dart';

abstract class LeaveApprovalEvent extends Equatable {
  const LeaveApprovalEvent();

  @override
  List<Object> get props => [];
}

class LoadPendingLeaves extends LeaveApprovalEvent {
  final bool isSilent;
  const LoadPendingLeaves({this.isSilent = false});

  @override
  List<Object> get props => [isSilent];
}

class ApproveLeave extends LeaveApprovalEvent {
  final int requestId;
  const ApproveLeave({required this.requestId});

  @override
  List<Object> get props => [requestId];
}

class RejectLeave extends LeaveApprovalEvent {
  final int requestId;
  final String reason;
  const RejectLeave({required this.requestId, required this.reason});

  @override
  List<Object> get props => [requestId, reason];
}
