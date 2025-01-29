import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/get_all_transaction.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/upload_transaction_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final UploadTransactionUsecase _uploadTransactionUsecase;
  final GetAllTransaction _getAllTransaction;
  TransactionBloc(
      {required UploadTransactionUsecase uploadTransactionUsecase,
      required GetAllTransaction getAllTransaction})
      : _uploadTransactionUsecase = uploadTransactionUsecase,
        _getAllTransaction = getAllTransaction,
        super(TransactionInitial()) {
    on<TransactionEvent>((event, emit) => emit(TransactionLoading()));
    on<TrsansactionUpload>(_onTransactionUpload);
    on<FetchAllTransaction>(_onFetchAllTransaction);
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
}
