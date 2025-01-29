import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/datepicker_usecase.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/category_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/transaction_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_button.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_field.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_field_icon.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddTransactionPage(),
      );
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<AddTransactionPage> {
  final moneyController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String selectedStatus = 'Income';
  final DatePickerUseCase _datePickerUseCase = DatePickerUseCase();

  void uploadTransaction() {
    if (formKey.currentState!.validate()) {
      final ownerId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<TransactionBloc>().add(
            TrsansactionUpload(
              ownerId: ownerId,
              money: double.parse(moneyController.text.trim()),
              category: categoryController.text.trim(),
              transactionStatus: selectedStatus,
              date: DateTime.parse(
                dateController.text.trim(),
              ),
            ),
          );
    }
  }

  @override
  void dispose() {
    moneyController.dispose();
    categoryController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await _datePickerUseCase.pickDate(context);
    if (selectedDate != null) {
      setState(() {
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionFailure) {
          showSnackBar(context, state.error);
        } else if (state is TransactionUploadSuccess) {
          Navigator.pushAndRemoveUntil(
              context, TransactionPage.route(), (route) => false);
        }
      },
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const LoaderWidget();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Transaction'),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // Transaction Status Toggle
                Container(
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
                            'Transaction Status',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppPallete.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: AppPallete.whiteColor,
                        thickness: 2,
                      ),
                      // Transaction Status Buttons (Income and Disbursement)
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppPallete.whiteColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Income Button
                            Expanded(
                              child: TransactionButton(
                                onPressed: (() {
                                  setState(() {
                                    selectedStatus = 'Income';
                                  });
                                }),
                                textButton: 'Income',
                                backgroundColor: selectedStatus == 'Income'
                                    ? AppPallete.gradient2
                                    : AppPallete.greyColor,
                                buttonSize: const Size(0, 0),
                              ),
                            ),
                            const SizedBox(width: 5), // Space between buttons
                            // Disbursement Button
                            Expanded(
                              child: TransactionButton(
                                onPressed: (() {
                                  setState(() {
                                    selectedStatus = 'Disbursement';
                                  });
                                }),
                                textButton: 'Disbursement',
                                backgroundColor:
                                    selectedStatus == 'Disbursement'
                                        ? AppPallete.gradient2
                                        : AppPallete.greyColor,
                                buttonSize: const Size(0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Money, Category, and Date Fields
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppPallete.gradient2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const TransactionText(
                        text: 'Money',
                        iconText: Icons.money_rounded,
                      ),
                      const SizedBox(height: 5),
                      TransactionFieldIcon(
                        hintText: 'Ex. 5000',
                        hintIcon: const Icon(
                          CupertinoIcons.money_dollar,
                        ),
                        controller: moneyController,
                      ),
                      const SizedBox(height: 10),
                      const TransactionText(
                        text: 'Category',
                        iconText: Icons.category,
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            CategoryPage.route(),
                          );

                          if (result != null) {
                            setState(() {
                              categoryController.text = result.toString();
                            });
                          }
                        },
                        child: TransactionField(
                          hintText: 'Click to select category',
                          controller: categoryController,
                          isEnable: false,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TransactionText(
                        text: 'Date',
                        iconText: CupertinoIcons.calendar,
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: _selectDate,
                        child: TransactionField(
                          hintText: 'Click to select date',
                          controller: dateController,
                          isEnable: false,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Add Transaction Button
                TransactionButton(
                  textButton: 'Add Transaction',
                  onPressed: () => uploadTransaction(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
