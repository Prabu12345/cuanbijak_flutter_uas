import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateTransactionUsecase
    implements Usecase<TransactionEntity, UpdateTransactionUsecaseParams> {
  final TransactionRepository transactionRepository;
  UpdateTransactionUsecase(this.transactionRepository);

  @override
  Future<Either<Failure, TransactionEntity>> call(params) async {
    return await transactionRepository.updateTransaction(
      id: params.id,
      ownerId: params.ownerId,
      money: params.money,
      category: params.category,
      date: params.date,
      transactionStatus: params.transactionStatus,
    );
  }
}

class UpdateTransactionUsecaseParams {
  final String id;
  final String ownerId;
  final double money;
  final String category;
  final DateTime date;
  final String transactionStatus;

  UpdateTransactionUsecaseParams({
    required this.id,
    required this.ownerId,
    required this.money,
    required this.category,
    required this.date,
    required this.transactionStatus,
  });
}
