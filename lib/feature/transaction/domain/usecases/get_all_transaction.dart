import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllTransaction
    implements Usecase<List<TransactionEntity>, GetAllTransactionParams> {
  final TransactionRepository transactionRepository;
  GetAllTransaction(this.transactionRepository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(
      GetAllTransactionParams params) async {
    return await transactionRepository.getAllTransaction(params.ownerId);
  }
}

class GetAllTransactionParams {
  final String ownerId;

  GetAllTransactionParams(
    this.ownerId,
  );
}
