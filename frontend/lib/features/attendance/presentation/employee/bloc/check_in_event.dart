part of 'check_in_bloc.dart';

abstract class CheckInEvent extends Equatable {
  const CheckInEvent();

  @override
  List<Object> get props => [];
}

class CheckIn extends CheckInEvent {
  final double latitude;
  final double longitude;
  final String notes;

  const CheckIn({
    required this.latitude,
    required this.longitude,
    required this.notes,
  });

  @override
  List<Object> get props => [latitude, longitude, notes];
}

class CheckOut extends CheckInEvent {
  final double latitude;
  final double longitude;

  const CheckOut({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}

class GetTodayAttendance extends CheckInEvent {}
