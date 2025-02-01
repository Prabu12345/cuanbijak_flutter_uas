import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TransactionRepository {
  Future<Either<Failure, TransactionEntity>> uploadTransaction({
    required String ownerId,
    required double money,
    required String category,
    required DateTime date,
    required String transactionStatus,
  });

  Future<Either<Failure, List<TransactionEntity>>> getAllTransaction(
      String ownerId);

  Future<Either<Failure, List<TransactionEntity>>> getAllFilteredTransaction({
    required String ownerId,
    required String filter,
  });

  Future<Either<Failure, TransactionEntity>> updateTransaction({
    required String id,
    required String ownerId,
    required double money,
    required String category,
    required DateTime date,
    required String transactionStatus,
  });
}
