import 'dart:io';

import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/common/entities/user_entity.dart';
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
  Future<Either<Failure, UserEntity>> currentUser();
  Future<Either<Failure, bool>> logoutUser();
  Future<Either<Failure, UserEntity>> updateUserData({
    required String id,
    required String name,
    required String phoneNumber,
    File? image,
  });
  Future<Either<Failure, bool>> changePassword({
    required String password,
  });
}
