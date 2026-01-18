import '../../domain/entities/attendance_record.dart';

class AttendanceModel extends AttendanceRecord {
  const AttendanceModel({
    required super.id,
    required super.userId,
    required super.date,
    super.checkIn,
    super.checkOut,
    super.latitudeIn,
    super.longitudeIn,
    required super.status,
    super.riskScore,
    super.userName,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    String? name;
    if (json['user'] != null && json['user'] is Map) {
      name = json['user']['name'];
    }

    return AttendanceModel(
      id: json['id'],
      userId: json['user_id'] is int
          ? json['user_id']
          : int.parse(json['user_id'].toString()),
      date: json['date'],
      checkIn:
          json['check_in_time'] ??
          json['check_in'], // Support both column names
      checkOut: json['check_out_time'] ?? json['check_out'],
      latitudeIn: json['latitude_in'] != null
          ? double.tryParse(json['latitude_in'].toString())
          : null,
      longitudeIn: json['longitude_in'] != null
          ? double.tryParse(json['longitude_in'].toString())
          : null,
      status: json['status'] ?? 'absent',
      riskScore: json['risk_score'] != null
          ? double.tryParse(json['risk_score'].toString())
          : null,
      userName: name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'check_in': checkIn,
      'check_out': checkOut,
      'latitude_in': latitudeIn,
      'longitude_in': longitudeIn,
      'status': status,
      'risk_score': riskScore,
    };
  }
}
