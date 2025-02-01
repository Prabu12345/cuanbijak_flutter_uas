import 'package:cuanbijak_flutter_uas/core/error/exceptions.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/data/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class TransactionRemoteDatasource {
  Future<TransactionModel> uploadTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getAllTransaction(String ownerId);
  Future<List<TransactionModel>> getAllFilteredTransaction({
    required String ownerId,
    required String filter,
  });
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<TransactionModel> deleteTransaction({
    required String ownerId,
    required String id,
  });
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

  @override
  Future<List<TransactionModel>> getAllFilteredTransaction(
      {required String ownerId, required String filter}) async {
    try {
      DateTime? startDate;
      final now = DateTime.now();

      switch (filter.toLowerCase()) {
        case 'last 7d':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case 'last 30d':
          startDate = now.subtract(const Duration(days: 30));
          break;
        case 'last 6m':
          startDate = DateTime(now.year, now.month - 6, now.day);
          break;
        case 'this year':
          startDate = DateTime(now.year, 1, 1);
          break;
        default:
          startDate = null;
      }

      var query =
          supabaseClient.from('transaction').select().eq('owner_id', ownerId);

      if (startDate != null) {
        query = query.gte('date', startDate.toIso8601String());
      }

      final response = await query;

      List<TransactionModel> transactions = (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();

      transactions.sort((a, b) => b.date.compareTo(a.date));

      return transactions;
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
      TransactionModel transaction) async {
    try {
      final response = await supabaseClient
          .from('transaction')
          .update(transaction.toJson())
          .eq('id', transaction.id)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }

  @override
  Future<TransactionModel> deleteTransaction({
    required String ownerId,
    required String id,
  }) async {
    try {
      final response = await supabaseClient
          .from('transaction')
          .delete()
          .eq('id', id)
          .eq('owner_id', ownerId)
          .select();

      return TransactionModel.fromJson(response.first);
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }
}
