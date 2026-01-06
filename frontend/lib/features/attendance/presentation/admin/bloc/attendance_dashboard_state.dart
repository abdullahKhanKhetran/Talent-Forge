part of 'attendance_dashboard_bloc.dart';

abstract class AttendanceDashboardState extends Equatable {
  const AttendanceDashboardState();

  @override
  List<Object?> get props => [];
}

class AttendanceDashboardInitial extends AttendanceDashboardState {}

class AttendanceDashboardLoading extends AttendanceDashboardState {}

class AttendanceDashboardLoaded extends AttendanceDashboardState {
  final List<AttendanceRecord> records;

  const AttendanceDashboardLoaded({required this.records});

  @override
  List<Object?> get props => [records];
}

class AttendanceDashboardFailure extends AttendanceDashboardState {
  final String message;

  const AttendanceDashboardFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
