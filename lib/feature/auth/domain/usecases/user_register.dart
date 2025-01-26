import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserRegister implements Usecase<UserEntity, UserRegisterParams> {
  final AuthRepository authRepository;
  const UserRegister(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UserRegisterParams params) async {
    return await authRepository.registerWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserRegisterParams {
  final String name;
  final String email;
  final String password;
  UserRegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
