import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceModel> checkIn(double lat, double long, String notes);
  Future<AttendanceModel> checkOut(double lat, double long);
  Future<List<AttendanceModel>> getAttendanceHistory();
  Future<List<AttendanceModel>> getLiveAttendance();
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final DioClient dioClient;

  AttendanceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AttendanceModel> checkIn(double lat, double long, String notes) async {
    try {
      final response = await dioClient.post(
        '/attendance/check-in',
        data: {'latitude': lat, 'longitude': long, 'notes': notes},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendanceModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Check-in failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<AttendanceModel> checkOut(double lat, double long) async {
    try {
      final response = await dioClient.post(
        '/attendance/check-out',
        data: {'latitude': lat, 'longitude': long},
      );
      if (response.statusCode == 200) {
        return AttendanceModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Check-out failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory() async {
    try {
      final response = await dioClient.get('/attendance/history');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => AttendanceModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch history',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<List<AttendanceModel>> getLiveAttendance() async {
    try {
      final response = await dioClient.get('/attendance/live');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => AttendanceModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch live stats',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }
}
