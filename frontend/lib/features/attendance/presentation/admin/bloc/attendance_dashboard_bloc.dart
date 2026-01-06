import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/attendance_record.dart';
import '../../../domain/repositories/attendance_repository.dart';

part 'attendance_dashboard_event.dart';
part 'attendance_dashboard_state.dart';

class AttendanceDashboardBloc
    extends Bloc<AttendanceDashboardEvent, AttendanceDashboardState> {
  final AttendanceRepository repository;

  AttendanceDashboardBloc({required this.repository})
    : super(AttendanceDashboardInitial()) {
    on<LoadLiveAttendance>(_onLoadLiveAttendance);
  }

  Future<void> _onLoadLiveAttendance(
    LoadLiveAttendance event,
    Emitter<AttendanceDashboardState> emit,
  ) async {
    emit(AttendanceDashboardLoading());

    final result = await repository.getLiveAttendance();

    result.fold(
      (failure) => emit(AttendanceDashboardFailure(message: failure.message)),
      (records) => emit(AttendanceDashboardLoaded(records: records)),
    );
  }
}
