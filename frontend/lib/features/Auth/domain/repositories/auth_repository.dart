import 'package:dartz/dartz.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, User>> getCurrentUser();
}
