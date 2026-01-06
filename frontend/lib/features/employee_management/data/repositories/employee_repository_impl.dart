import 'package:dartz/dartz.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_remote_datasource.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<User>>> getEmployees() async {
    try {
      final result = await remoteDataSource.getEmployees();
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> addEmployee(Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.addEmployee(data);
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateEmployee(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await remoteDataSource.updateEmployee(id, data);
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(String id) async {
    try {
      await remoteDataSource.deleteEmployee(id);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getDepartments() async {
    try {
      final result = await remoteDataSource.getDepartments();
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
