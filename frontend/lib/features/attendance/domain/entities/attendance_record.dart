import 'package:equatable/equatable.dart';

class AttendanceRecord extends Equatable {
  final int id;
  final int userId;
  final String date;
  final String? checkIn;
  final String? checkOut;
  final double? latitudeIn;
  final double? longitudeIn;
  final String status;
  final double? riskScore;

  const AttendanceRecord({
    required this.id,
    required this.userId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.latitudeIn,
    this.longitudeIn,
    required this.status,
    this.riskScore,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    checkIn,
    checkOut,
    latitudeIn,
    longitudeIn,
    status,
    riskScore,
  ];
}
