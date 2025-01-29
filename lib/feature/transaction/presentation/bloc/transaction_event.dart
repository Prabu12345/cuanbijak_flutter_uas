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
