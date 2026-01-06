import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/leave_balance.dart';
import '../../../domain/entities/leave_request.dart';
import '../../../domain/entities/leave_type.dart';
import '../../../domain/repositories/leave_repository.dart';

part 'leave_request_event.dart';
part 'leave_request_state.dart';

class LeaveRequestBloc extends Bloc<LeaveRequestEvent, LeaveRequestState> {
  final LeaveRepository repository;

  LeaveRequestBloc({required this.repository}) : super(LeaveRequestInitial()) {
    on<LoadLeaveDashboard>(_onLoadDashboard);
    on<SubmitLeaveRequest>(_onSubmitRequest);
  }

  Future<void> _onLoadDashboard(
    LoadLeaveDashboard event,
    Emitter<LeaveRequestState> emit,
  ) async {
    emit(LeaveRequestLoading());

    final typesResult = await repository.getLeaveTypes();
    final balancesResult = await repository.getLeaveBalances();
    final historyResult = await repository.getMyLeaveRequests();

    // Combine results
    // Ideally use functional programming to zip them, but simple nested folding is easier for now to read
    typesResult.fold(
      (failure) => emit(LeaveRequestFailure(message: failure.message)),
      (types) {
        balancesResult.fold(
          (failure) => emit(LeaveRequestFailure(message: failure.message)),
          (balances) {
            historyResult.fold(
              (failure) => emit(LeaveRequestFailure(message: failure.message)),
              (history) => emit(
                LeaveDashboardLoaded(
                  leaveTypes: types,
                  balances: balances,
                  requestHistory: history,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onSubmitRequest(
    SubmitLeaveRequest event,
    Emitter<LeaveRequestState> emit,
  ) async {
    // Keep current loaded state if possible, but for simplicity we emit loading
    // In a real app we might want to keep the dashboard visible while submitting
    emit(LeaveRequestLoading());

    final result = await repository.submitLeaveRequest(
      leaveTypeId: event.leaveTypeId,
      startDate: event.startDate,
      endDate: event.endDate,
      reason: event.reason,
    );

    result.fold(
      (failure) => emit(LeaveRequestFailure(message: failure.message)),
      (_) {
        // Reload dashboard to update balances and history
        add(LoadLeaveDashboard());
      },
    );
  }
}
