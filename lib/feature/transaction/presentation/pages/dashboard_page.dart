import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/calculate_money.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late UserEntity user;

  @override
  void initState() {
    super.initState();
    user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    context.read<TransactionBloc>().add(FetchAllTransaction(user.id));
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
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // User Card Section
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppPallete.gradient2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${user.name}!',
                          style: const TextStyle(
                            color: AppPallete.whiteColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$ ${calculateTotalMoney(state.transaction)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Recent Transaction Section
              Container(
                height: 275,
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
                          'Recent Transaction',
                          style: TextStyle(
                            fontSize: 17,
                            color: AppPallete.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: AppPallete.whiteColor, // Line color
                      thickness: 2, // Line thickness
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: 4,
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
              const SizedBox(height: 20),
            ],
          );
        }

        return const SizedBox(
          height: 1,
        );
      },
    );
  }
}
