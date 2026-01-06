import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/leave_request.dart';
import '../../../domain/repositories/leave_repository.dart';

part 'leave_approval_event.dart';
part 'leave_approval_state.dart';

class LeaveApprovalBloc extends Bloc<LeaveApprovalEvent, LeaveApprovalState> {
  final LeaveRepository repository;

  LeaveApprovalBloc({required this.repository})
    : super(LeaveApprovalInitial()) {
    on<LoadPendingLeaves>(_onLoadPending);
    on<ApproveLeave>(_onApprove);
    on<RejectLeave>(_onReject);
  }

  Future<void> _onLoadPending(
    LoadPendingLeaves event,
    Emitter<LeaveApprovalState> emit,
  ) async {
    emit(LeaveApprovalLoading());
    final result = await repository.getPendingLeaves();
    result.fold(
      (failure) => emit(LeaveApprovalFailure(message: failure.message)),
      (leaves) => emit(LeaveApprovalLoaded(pendingLeaves: leaves)),
    );
  }

  Future<void> _onApprove(
    ApproveLeave event,
    Emitter<LeaveApprovalState> emit,
  ) async {
    emit(LeaveApprovalLoading());
    final result = await repository.approveLeave(event.requestId);
    result.fold(
      (failure) => emit(LeaveApprovalFailure(message: failure.message)),
      (_) => add(LoadPendingLeaves()), // Reload
    );
  }

  Future<void> _onReject(
    RejectLeave event,
    Emitter<LeaveApprovalState> emit,
  ) async {
    emit(LeaveApprovalLoading());
    final result = await repository.rejectLeave(event.requestId, event.reason);
    result.fold(
      (failure) => emit(LeaveApprovalFailure(message: failure.message)),
      (_) => add(LoadPendingLeaves()), // Reload
    );
  }
}
