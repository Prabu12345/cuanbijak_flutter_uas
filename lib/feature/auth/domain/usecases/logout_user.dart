import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUser implements Usecase<bool, NoParams> {
  final AuthRepository authRepository;
  const LogoutUser(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await authRepository.logoutUser();
  }
}
