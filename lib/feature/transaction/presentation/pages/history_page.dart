import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/add_transaction_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_button.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    final ownerId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<TransactionBloc>().add(FetchAllTransaction(ownerId));
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
          return Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                TransactionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      AddTransactionPage.route(),
                    );
                  },
                  textButton: 'Add Transaction',
                  buttonSize: const Size(395, 50),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppPallete.gradient2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'History Transaction',
                              style: TextStyle(
                                fontSize: 17,
                                color: AppPallete.whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: AppPallete.whiteColor, // Line color
                          thickness: 2, // Line thickness
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Scrollbar(
                            child: ListView.builder(
                              itemCount: state.transaction.length,
                              itemBuilder: (context, index) {
                                final transaction = state.transaction[index];
                                return TransactionCard(
                                  transactions: transaction,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox(
          height: 1,
        );
      },
    );
  }
}
