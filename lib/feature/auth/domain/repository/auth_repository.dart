import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}
