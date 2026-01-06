part of 'check_in_bloc.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object?> get props => [];
}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInSuccess extends CheckInState {
  final AttendanceRecord record;
  final String message;

  const CheckInSuccess({required this.record, required this.message});

  @override
  List<Object?> get props => [record, message];
}

class CheckInFailure extends CheckInState {
  final String message;

  const CheckInFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class TodayAttendanceLoaded extends CheckInState {
  final List<AttendanceRecord> records;

  const TodayAttendanceLoaded({required this.records});

  @override
  List<Object?> get props => [records];
}
