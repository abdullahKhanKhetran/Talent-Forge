import 'package:dartz/dartz.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failures.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<User>>> getEmployees();
  Future<Either<Failure, User>> addEmployee(Map<String, dynamic> data);
  Future<Either<Failure, User>> updateEmployee(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deleteEmployee(String id);
  Future<Either<Failure, List<dynamic>>> getDepartments();
}
