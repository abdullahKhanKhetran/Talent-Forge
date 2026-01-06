import 'package:dartz/dartz.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final res = await authRemoteDataSource.getCurrentUserData();
      if (res != null) {
        return right(res);
      }
      return left(AuthFailure(message: "No user logged in"));
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await authRemoteDataSource.signIn(
        email: email,
        password: password,
      );
      return right(res);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      final res = await authRemoteDataSource.signOut();
      return right(res);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
