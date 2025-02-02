import 'dart:io';

import 'package:cuanbijak_flutter_uas/core/error/exceptions.dart';
import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:cuanbijak_flutter_uas/core/common/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      return right(user);
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loignWIthEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.registerWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> logoutUser() async {
    try {
      final respone = await remoteDataSource.logoutUser();
      return right(respone);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserData({
    required String id,
    required String name,
    required String phoneNumber,
    File? image,
  }) async {
    try {
      var user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      user = user.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        updatedAt: DateTime.now(),
      );

      if (image != null) {
        final avatarUrl = await remoteDataSource.uploadAvatar(
          user: user,
          image: image,
        );

        user = user.copyWith(
          avatarUrl: avatarUrl,
        );
      }

      final updatedUser = await remoteDataSource.updateUserData(user: user);
      return right(updatedUser);
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword(
      {required String password}) async {
    try {
      final reponse = await remoteDataSource.changePassword(password: password);

      return right(reponse);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, UserEntity>> _getUser(
    Future<UserEntity> Function() func,
  ) async {
    try {
      final user = await func();

      return right(user);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }
}
