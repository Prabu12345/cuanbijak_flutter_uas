import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadTransactionUsecase
    implements Usecase<TransactionEntity, UploadTransactionUsecaseParams> {
  final TransactionRepository transactionRepository;
  UploadTransactionUsecase(this.transactionRepository);

  @override
  Future<Either<Failure, TransactionEntity>> call(params) async {
    return await transactionRepository.uploadTransaction(
      ownerId: params.ownerId,
      money: params.money,
      category: params.category,
      date: params.date,
      transactionStatus: params.transactionStatus,
    );
  }
}

class UploadTransactionUsecaseParams {
  final String ownerId;
  final double money;
  final String category;
  final DateTime date;
  final String transactionStatus;

  UploadTransactionUsecaseParams({
    required this.ownerId,
    required this.money,
    required this.category,
    required this.date,
    required this.transactionStatus,
  });
}
