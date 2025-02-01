import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllFilteredTransaction
    implements
        Usecase<List<TransactionEntity>, GetAllFilteredTransactionParams> {
  final TransactionRepository transactionRepository;
  GetAllFilteredTransaction(this.transactionRepository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(
      GetAllFilteredTransactionParams params) async {
    return await transactionRepository.getAllFilteredTransaction(
        ownerId: params.ownerId, filter: params.filter);
  }
}

class GetAllFilteredTransactionParams {
  final String ownerId;
  final String filter;

  GetAllFilteredTransactionParams({
    required this.ownerId,
    required this.filter,
  });
}
