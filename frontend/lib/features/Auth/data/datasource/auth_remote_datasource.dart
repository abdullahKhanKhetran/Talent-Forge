import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel?> getCurrentUserData();
  Future<Unit> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];

        await dioClient.saveTokens(accessToken: token);

        return UserModel.fromJson(data['user']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? "Login failed",
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final response = await dioClient.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      }
      return null;
    } catch (e) {
      // If unauthorized, return null, otherwise throw
      // For now, simplify to null to trigger logout
      return null;
    }
  }

  @override
  Future<Unit> signOut() async {
    try {
      await dioClient.post('/auth/logout');
      await dioClient.clearTokens();
      return unit;
    } catch (e) {
      // Even if API fails, clear local tokens
      await dioClient.clearTokens();
      return unit;
    }
  }
}
