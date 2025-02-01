import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteTransaction
    implements Usecase<TransactionEntity, DeleteTransactionParams> {
  final TransactionRepository transactionRepository;
  DeleteTransaction(this.transactionRepository);

  @override
  Future<Either<Failure, TransactionEntity>> call(
      DeleteTransactionParams params) async {
    return await transactionRepository.deleteTransaction(
        ownerId: params.ownerId, id: params.id);
  }
}

class DeleteTransactionParams {
  final String ownerId;
  final String id;

  DeleteTransactionParams({required this.ownerId, required this.id});
}
