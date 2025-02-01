part of 'transaction_bloc.dart';

@immutable
sealed class TransactionEvent {}

final class TrsansactionUpload extends TransactionEvent {
  final String ownerId;
  final double money;
  final String category;
  final String transactionStatus;
  final DateTime date;

  TrsansactionUpload({
    required this.ownerId,
    required this.money,
    required this.category,
    required this.transactionStatus,
    required this.date,
  });
}

final class FetchAllTransaction extends TransactionEvent {
  final String ownerId;
  FetchAllTransaction(this.ownerId);
}

final class FilterTransactions extends TransactionEvent {
  final String ownerId;
  final String filter;

  FilterTransactions({required this.ownerId, required this.filter});
}

final class UpdateTransaction extends TransactionEvent {
  final String id;
  final String ownerId;
  final double money;
  final String category;
  final String transactionStatus;
  final DateTime date;

  UpdateTransaction({
    required this.id,
    required this.ownerId,
    required this.money,
    required this.category,
    required this.transactionStatus,
    required this.date,
  });
}

final class DeleteTransactions extends TransactionEvent {
  final String ownerId;
  final String id;

  DeleteTransactions({required this.ownerId, required this.id});
}
