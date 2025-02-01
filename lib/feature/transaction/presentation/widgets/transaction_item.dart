import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/currencyFormat.dart';
import 'package:cuanbijak_flutter_uas/core/utils/formated_date.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;
  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.transactionStatus == 'Income';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppPallete.greyColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isIncome
                  ? AppPallete.greenColor700.withOpacity(0.1)
                  : AppPallete.errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color:
                  isIncome ? AppPallete.greenColor700 : AppPallete.errorColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDateByDDMMMMYYYY(transaction.date),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppPallete.greyColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currenctyFormat(transaction.money),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  isIncome ? AppPallete.greenColor700 : AppPallete.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
