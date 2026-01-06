part of 'attendance_dashboard_bloc.dart';

abstract class AttendanceDashboardEvent extends Equatable {
  const AttendanceDashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadLiveAttendance extends AttendanceDashboardEvent {}
