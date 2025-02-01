import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/get_all_filtered_transaction.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/get_all_transaction.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/update_transaction.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/upload_transaction_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final UploadTransactionUsecase _uploadTransactionUsecase;
  final GetAllTransaction _getAllTransaction;
  final GetAllFilteredTransaction _getAllFilteredTransaction;
  final UpdateTransactionUsecase _updateTransactionUsecase;
  TransactionBloc({
    required UploadTransactionUsecase uploadTransactionUsecase,
    required GetAllTransaction getAllTransaction,
    required GetAllFilteredTransaction getAllFilteredTransaction,
    required UpdateTransactionUsecase updateTransactionUsecase,
  })  : _uploadTransactionUsecase = uploadTransactionUsecase,
        _getAllTransaction = getAllTransaction,
        _getAllFilteredTransaction = getAllFilteredTransaction,
        _updateTransactionUsecase = updateTransactionUsecase,
        super(TransactionInitial()) {
    on<TransactionEvent>((event, emit) => emit(TransactionLoading()));
    on<TrsansactionUpload>(_onTransactionUpload);
    on<FetchAllTransaction>(_onFetchAllTransaction);
    on<FilterTransactions>(_onFetchAllFiltredTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
  }

  void _onTransactionUpload(
      TrsansactionUpload event, Emitter<TransactionState> emit) async {
    final response = await _uploadTransactionUsecase(
      UploadTransactionUsecaseParams(
        ownerId: event.ownerId,
        money: event.money,
        category: event.category,
        date: event.date,
        transactionStatus: event.transactionStatus,
      ),
    );

    response.fold(
      (l) => emit(TransactionFailure(l.message)),
      (r) => emit(TransactionUploadSuccess()),
    );
  }

  void _onFetchAllTransaction(
    FetchAllTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    final response =
        await _getAllTransaction(GetAllTransactionParams(event.ownerId));

    response.fold(
      (l) => emit(TransactionFailure(l.message)),
      (r) => emit(TransactionDisplaySuccess(r)),
    );
  }

  void _onFetchAllFiltredTransaction(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    final response = await _getAllFilteredTransaction(
        GetAllFilteredTransactionParams(
            ownerId: event.ownerId, filter: event.filter));

    response.fold(
      (l) => emit(TransactionFailure(l.message)),
      (r) => emit(TransactionDisplaySuccess(r)),
    );
  }

  void _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    final response =
        await _updateTransactionUsecase(UpdateTransactionUsecaseParams(
      id: event.id,
      ownerId: event.ownerId,
      money: event.money,
      category: event.category,
      date: event.date,
      transactionStatus: event.transactionStatus,
    ));

    response.fold(
      (l) => emit(TransactionFailure(l.message)),
      (r) => emit(TransactionUpdateSuccess()),
    );
  }
}
