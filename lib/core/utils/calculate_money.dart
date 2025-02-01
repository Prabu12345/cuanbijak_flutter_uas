import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';

double calculateTotalMoney(List<TransactionEntity> transaction) {
  double sum = 0;

  for (var t in transaction) {
    t.transactionStatus == 'Income' ? sum += t.money : sum -= t.money;
  }

  return sum;
}
