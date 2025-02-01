part of 'transaction_bloc.dart';

@immutable
sealed class TransactionState {}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class TransactionFailure extends TransactionState {
  final String error;
  TransactionFailure(this.error);
}

final class TransactionUploadSuccess extends TransactionState {}

final class TransactionUpdateSuccess extends TransactionState {}

final class TransactionDisplaySuccess extends TransactionState {
  final List<TransactionEntity> transaction;
  TransactionDisplaySuccess(this.transaction);
}
