import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/leave_balance_model.dart';
import '../models/leave_request_model.dart';
import '../models/leave_type_model.dart';

abstract class LeaveRemoteDataSource {
  Future<List<LeaveTypeModel>> getLeaveTypes();
  Future<List<LeaveBalanceModel>> getLeaveBalances();
  Future<List<LeaveRequestModel>> getMyLeaveRequests();
  Future<LeaveRequestModel> submitLeaveRequest(Map<String, dynamic> data);
  // Admin
  Future<List<LeaveRequestModel>> getPendingLeaves();
  Future<LeaveRequestModel> approveLeave(int id);
  Future<LeaveRequestModel> rejectLeave(int id, String reason);
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final DioClient dioClient;

  LeaveRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<LeaveTypeModel>> getLeaveTypes() async {
    try {
      final response = await dioClient.get('/leave-types');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => LeaveTypeModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch leave types',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<List<LeaveBalanceModel>> getLeaveBalances() async {
    try {
      final response = await dioClient.get('/leave-balances');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => LeaveBalanceModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch balances',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<List<LeaveRequestModel>> getMyLeaveRequests() async {
    try {
      final response = await dioClient.get('/leaves/my-requests');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => LeaveRequestModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch requests',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<LeaveRequestModel> submitLeaveRequest(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dioClient.post('/leaves', data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeaveRequestModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Submission failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<List<LeaveRequestModel>> getPendingLeaves() async {
    try {
      final response = await dioClient.get('/admin/leaves/pending');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => LeaveRequestModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch pending leaves',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<LeaveRequestModel> approveLeave(int id) async {
    try {
      final response = await dioClient.post('/admin/leaves/$id/approve');
      if (response.statusCode == 200) {
        return LeaveRequestModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Approval failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }

  @override
  Future<LeaveRequestModel> rejectLeave(int id, String reason) async {
    try {
      final response = await dioClient.post(
        '/admin/leaves/$id/reject',
        data: {'rejection_reason': reason},
      );
      if (response.statusCode == 200) {
        return LeaveRequestModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Rejection failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Unknown Error',
      );
    }
  }
}
