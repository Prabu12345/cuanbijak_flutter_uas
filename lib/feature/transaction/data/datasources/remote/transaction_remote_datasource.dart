import 'package:cuanbijak_flutter_uas/core/error/exceptions.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/data/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class TransactionRemoteDatasource {
  Future<TransactionModel> uploadTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getAllTransaction(String ownerId);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final SupabaseClient supabaseClient;
  TransactionRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<TransactionModel> uploadTransaction(
      TransactionModel transaction) async {
    try {
      final transactionData = await supabaseClient
          .from('transaction')
          .insert(transaction.toJson())
          .select();
      return TransactionModel.fromJson(transactionData.first);
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransaction(String ownerId) async {
    try {
      final transactions = await supabaseClient
          .from('transaction')
          .select()
          .eq('owner_id', ownerId)
          .order('date', ascending: false);
      return transactions.map((t) => TransactionModel.fromJson(t)).toList();
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }
}
