import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/formated_date.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity transactions;
  const TransactionCard({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 14,
          right: 14,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              '${transactions.transactionStatus} - ${transactions.category}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppPallete.greyColor700,
              ),
            ),
            const SizedBox(height: 1),

            // Amount and Time row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Amount
                Text(
                  "\$ ${transactions.money.toString()}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: transactions.transactionStatus.contains('Income')
                        ? AppPallete.greenColor700
                        : AppPallete.redColor700,
                  ),
                ),

                // Time
                Text(
                  formatDateByDDMMMMYYYY(transactions.date),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppPallete.greyColor700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
