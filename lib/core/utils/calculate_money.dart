import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';

double calculateTotalMoney(List<TransactionEntity> transaction) {
  double totalMoney = 0;

  for (var t in transaction) {
    totalMoney += t.money;
  }

  return totalMoney;
}
