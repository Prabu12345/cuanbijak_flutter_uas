import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/calculate_money.dart';
import 'package:cuanbijak_flutter_uas/core/utils/currencyFormat.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/add_transaction_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/edit_transaction_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedFilter = 'All';
  final List<String> filters = [
    'All',
    'Last 7d',
    'Last 30d',
    'Last 6M',
    'This Year'
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    final ownerId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<TransactionBloc>().add(FetchAllTransaction(ownerId));
  }

  void _filterTransactions(String filter) {
    final ownerId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<TransactionBloc>().add(FilterTransactions(
          ownerId: ownerId,
          filter: filter,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionFailure) {
          showSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const LoaderWidget();
        }
        if (state is TransactionDisplaySuccess) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.push(context, AddTransactionPage.route()),
              backgroundColor: AppPallete.gradient2,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Transaction',
                  style: TextStyle(color: Colors.white)),
              elevation: 4,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildFilterHeader(state.transaction),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _buildTransactionList(state.transaction),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFilterHeader(List<TransactionEntity> transaction) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppPallete.whiteColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.filter_alt,
                  color: AppPallete.gradient2, size: 28),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: selectedFilter,
                underline: Container(),
                items: filters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedFilter = value!);
                  _filterTransactions(value!);
                },
              ),
              const Spacer(),
              Text(
                'Total: ${currenctyFormat(calculateTotalMoney(transaction))}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.gradient2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToEdit(TransactionEntity transaction) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionPage(
          transactionToEdit: transaction,
        ),
      ),
    );

    if (result == true) {
      _loadTransactions();
    }
  }

  Widget _buildTransactionList(List<TransactionEntity> transactions) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: AppPallete.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return InkWell(
                onTap: () => _navigateToEdit(transaction),
                child: TransactionItem(
                  transaction: transaction,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
