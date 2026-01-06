import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/attendance_record.dart';
import '../../../domain/repositories/attendance_repository.dart';

part 'check_in_event.dart';
part 'check_in_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final AttendanceRepository repository;

  CheckInBloc({required this.repository}) : super(CheckInInitial()) {
    on<CheckIn>(_onCheckIn);
    on<CheckOut>(_onCheckOut);
    on<GetTodayAttendance>(_onGetTodayAttendance);
  }

  Future<void> _onCheckIn(CheckIn event, Emitter<CheckInState> emit) async {
    emit(CheckInLoading());
    final result = await repository.checkIn(
      latitude: event.latitude,
      longitude: event.longitude,
      notes: event.notes,
    );

    result.fold(
      (failure) => emit(CheckInFailure(message: failure.message)),
      (record) => emit(
        CheckInSuccess(record: record, message: 'Checked In Successfully'),
      ),
    );
  }

  Future<void> _onCheckOut(CheckOut event, Emitter<CheckInState> emit) async {
    emit(CheckInLoading());
    final result = await repository.checkOut(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    result.fold(
      (failure) => emit(CheckInFailure(message: failure.message)),
      (record) => emit(
        CheckInSuccess(record: record, message: 'Checked Out Successfully'),
      ),
    );
  }

  Future<void> _onGetTodayAttendance(
    GetTodayAttendance event,
    Emitter<CheckInState> emit,
  ) async {
    emit(CheckInLoading());
    final result = await repository.getAttendanceHistory();

    result.fold(
      (failure) => emit(CheckInFailure(message: failure.message)),
      (records) => emit(TodayAttendanceLoaded(records: records)),
    );
  }
}
