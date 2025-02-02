import 'dart:io';

import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/core/common/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUser implements Usecase<UserEntity, UpdateUserParams> {
  final AuthRepository authRepository;
  const UpdateUser(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) async {
    return await authRepository.updateUserData(
      id: params.id,
      name: params.name,
      phoneNumber: params.phoneNumber,
      image: params.image,
    );
  }
}

class UpdateUserParams {
  final String id;
  final String name;
  final String phoneNumber;
  final File? image;
  UpdateUserParams({
    required this.name,
    required this.id,
    required this.phoneNumber,
    this.image,
  });
}
