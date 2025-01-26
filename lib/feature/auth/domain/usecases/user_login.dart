import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements Usecase<UserEntity, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({
    required this.email,
    required this.password,
  });
}
