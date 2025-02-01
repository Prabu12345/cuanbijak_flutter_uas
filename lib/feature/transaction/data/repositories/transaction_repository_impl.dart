import 'package:cuanbijak_flutter_uas/core/error/exceptions.dart';
import 'package:cuanbijak_flutter_uas/core/error/failures.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/data/models/transaction_model.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDatasource transactionRemoteDatasource;
  TransactionRepositoryImpl(this.transactionRemoteDatasource);

  @override
  Future<Either<Failure, TransactionEntity>> uploadTransaction({
    required String ownerId,
    required double money,
    required String category,
    required DateTime date,
    required String transactionStatus,
  }) async {
    try {
      TransactionModel transactionModel = TransactionModel(
        id: const Uuid().v1(),
        ownerId: ownerId,
        money: money,
        category: category,
        date: date,
        updatedAt: DateTime.now(),
        transactionStatus: transactionStatus,
      );

      final uploadedTransaction =
          await transactionRemoteDatasource.uploadTransaction(transactionModel);
      return right(uploadedTransaction);
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransaction(
      String ownerId) async {
    try {
      final transactions =
          await transactionRemoteDatasource.getAllTransaction(ownerId);

      return right(transactions);
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllFilteredTransaction(
      {required String ownerId, required String filter}) async {
    try {
      final transactions = await transactionRemoteDatasource
          .getAllFilteredTransaction(ownerId: ownerId, filter: filter);

      return right(transactions);
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> updateTransaction(
      {required String id,
      required String ownerId,
      required double money,
      required String category,
      required DateTime date,
      required String transactionStatus}) async {
    try {
      TransactionModel transactionModel = TransactionModel(
        id: id,
        ownerId: ownerId,
        money: money,
        category: category,
        date: date,
        updatedAt: DateTime.now(),
        transactionStatus: transactionStatus,
      );

      final transactions =
          await transactionRemoteDatasource.updateTransaction(transactionModel);

      return right(transactions);
    } on ServerExpection catch (e) {
      return left(Failure(e.message));
    }
  }
}
