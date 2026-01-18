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
    if (!event.isSilent) {
      emit(LeaveApprovalLoading());
    }
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
    // Optimistic Update
    final currentState = state;
    if (currentState is LeaveApprovalLoaded) {
      final updatedLeaves = currentState.pendingLeaves
          .where((l) => l.id != event.requestId)
          .toList();
      emit(LeaveApprovalLoaded(pendingLeaves: updatedLeaves));
    }

    final result = await repository.approveLeave(event.requestId);
    result.fold(
      (failure) {
        emit(LeaveApprovalFailure(message: failure.message));
        add(const LoadPendingLeaves()); // Rollback/Refresh on failure
      },
      (_) => add(const LoadPendingLeaves(isSilent: true)), // Background refresh
    );
  }

  Future<void> _onReject(
    RejectLeave event,
    Emitter<LeaveApprovalState> emit,
  ) async {
    // Optimistic Update
    final currentState = state;
    if (currentState is LeaveApprovalLoaded) {
      final updatedLeaves = currentState.pendingLeaves
          .where((l) => l.id != event.requestId)
          .toList();
      emit(LeaveApprovalLoaded(pendingLeaves: updatedLeaves));
    }

    final result = await repository.rejectLeave(event.requestId, event.reason);
    result.fold(
      (failure) {
        emit(LeaveApprovalFailure(message: failure.message));
        add(const LoadPendingLeaves()); // Rollback/Refresh on failure
      },
      (_) => add(const LoadPendingLeaves(isSilent: true)), // Background refresh
    );
  }
}
