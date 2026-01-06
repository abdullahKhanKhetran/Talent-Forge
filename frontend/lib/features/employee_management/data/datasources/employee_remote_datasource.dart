import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../Auth/data/models/user_model.dart';
import '../../../../core/common/entities/user.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<UserModel>> getEmployees();
  Future<UserModel> addEmployee(Map<String, dynamic> data);
  Future<UserModel> updateEmployee(String id, Map<String, dynamic> data);
  Future<void> deleteEmployee(String id);
  Future<List<dynamic>> getDepartments();
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final DioClient dioClient;

  EmployeeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<UserModel>> getEmployees() async {
    try {
      final response = await dioClient.get('/employees');
      // Laravel returns { data: [...] }
      final List data = response.data['data'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> addEmployee(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.post('/employees', data: data);
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateEmployee(String id, Map<String, dynamic> data) async {
    try {
      final response = await dioClient.put('/employees/$id', data: data);
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    try {
      await dioClient.delete('/employees/$id');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<dynamic>> getDepartments() async {
    try {
      final response = await dioClient.get('/departments');
      return response.data['data'];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
