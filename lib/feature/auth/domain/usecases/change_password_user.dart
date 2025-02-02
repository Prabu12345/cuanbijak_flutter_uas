import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChangePasswordUser implements Usecase<bool, ChangePasswordUserParams> {
  final AuthRepository authRepository;
  const ChangePasswordUser(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(ChangePasswordUserParams params) async {
    return await authRepository.changePassword(
      password: params.password,
    );
  }
}

class ChangePasswordUserParams {
  final String password;
  ChangePasswordUserParams({
    required this.password,
  });
}
