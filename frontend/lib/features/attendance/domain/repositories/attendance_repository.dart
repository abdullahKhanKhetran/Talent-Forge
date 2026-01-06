import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_record.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceRecord>> checkIn({
    required double latitude,
    required double longitude,
    required String notes,
  });

  Future<Either<Failure, AttendanceRecord>> checkOut({
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceHistory();

  Future<Either<Failure, List<AttendanceRecord>>> getLiveAttendance(); // Admin
}
