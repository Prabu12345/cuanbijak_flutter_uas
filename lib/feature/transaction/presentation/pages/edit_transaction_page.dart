import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/datepicker_usecase.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/category_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/transaction_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_animated_submit_section.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_category_section.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_datepicker_section.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_money_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditTransactionPage extends StatefulWidget {
  final TransactionEntity? transactionToEdit;
  static route() => MaterialPageRoute(
        builder: (context) => const EditTransactionPage(),
      );
  const EditTransactionPage({super.key, this.transactionToEdit});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPage();
}

class _EditTransactionPage extends State<EditTransactionPage>
    with TickerProviderStateMixin {
  final _moneyController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  String selectedStatus = 'Income';
  final DatePickerUseCase _datePickerUseCase = DatePickerUseCase();

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.transactionToEdit != null) {
      _initializeEditMode();
    }
  }

  void _animateButton() {
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });
  }

  void uploadTransaction() {
    if (formKey.currentState!.validate()) {
      _animateButton();
      final ownerId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<TransactionBloc>().add(
            UpdateTransaction(
              id: widget.transactionToEdit!.id,
              ownerId: ownerId,
              money: double.parse(_moneyController.text.trim()),
              category: _categoryController.text.trim(),
              transactionStatus: selectedStatus,
              date: DateTime.parse(_dateController.text.trim()),
            ),
          );
    }
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _moneyController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await _datePickerUseCase.pickDate(context);
    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _initializeEditMode() {
    final transaction = widget.transactionToEdit!;
    _moneyController.text = transaction.money.toString();
    _categoryController.text = transaction.category;
    selectedStatus = transaction.transactionStatus;
    _dateController.text = DateFormat('yyyy-MM-dd').format(transaction.date);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionFailure) {
          showSnackBar(context, state.error);
        } else if (state is TransactionUpdateSuccess) {
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
            title: const Text('Edit Transaction'),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _buildAnimatedStatusToggle(),
                const SizedBox(height: 25),
                TransactionMoneySection(
                  controller: _moneyController,
                ),
                const SizedBox(height: 25),
                TransactionCategorySection(
                  onPress: () async {
                    final result =
                        await Navigator.push(context, CategoryPage.route());
                    if (result != null) {
                      setState(
                          () => _categoryController.text = result.toString());
                    }
                  },
                  controller: _categoryController,
                ),
                const SizedBox(height: 25),
                TransactionDatepickerSection(
                  onPress: _selectDate,
                  controller: _dateController,
                ),
                const SizedBox(height: 35),
                TransactionAnimatedSubmitSection(
                    controller: _buttonAnimationController,
                    onPress: uploadTransaction,
                    animation: _buttonScaleAnimation,
                    text: 'Edit Transaction'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedStatusToggle() {
    return Container(
      padding: const EdgeInsets.all(15),
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
      child: Column(
        children: [
          const Text(
            'Transaction Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPallete.gradient2,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: AppPallete.greyColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildStatusButton('Income', '💰'),
                _buildStatusButton('Disbursement', '💸'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status, String emoji) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedStatus = status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: selectedStatus == status
                ? AppPallete.gradient2
                : AppPallete.transparentColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 6),
              Text(
                status,
                style: TextStyle(
                  color: selectedStatus == status
                      ? Colors.white
                      : AppPallete.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
