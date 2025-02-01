import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/datepicker_usecase.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/category_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/transaction_page.dart';
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

class _TransactionPageState extends State<AddTransactionPage>
    with TickerProviderStateMixin {
  final _moneyController = TextEditingController();
  final _categoryController = TextEditingController();
  final dateController = TextEditingController();
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
            TrsansactionUpload(
              ownerId: ownerId,
              money: double.parse(_moneyController.text.trim()),
              category: _categoryController.text.trim(),
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
    _buttonAnimationController.dispose();
    _moneyController.dispose();
    _categoryController.dispose();
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
                // Animated Transaction Status Toggle
                _buildAnimatedStatusToggle(),
                const SizedBox(height: 25),
                // Money Input with Currency Animation
                _buildMoneyInputSection(),
                const SizedBox(height: 25),
                // Category Selection with Visual Feedback
                _buildCategorySection(),
                const SizedBox(height: 25),
                // Date Picker with Calendar Animation
                _buildDatePickerSection(),
                const SizedBox(height: 35),
                // Animated Submit Button
                _buildAnimatedSubmitButton(),
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
                : Colors.transparent,
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

  Widget _buildMoneyInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppPallete.gradient2,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _moneyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.attach_money_rounded,
                  color: AppPallete.gradient2),
              hintText: 'Enter amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppPallete.greyColor.withOpacity(0.1),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppPallete.gradient2,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final result =
                  await Navigator.push(context, CategoryPage.route());
              if (result != null) {
                setState(() => _categoryController.text = result.toString());
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppPallete.greyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.category, color: AppPallete.gradient2),
                  const SizedBox(width: 12),
                  Text(
                    _categoryController.text.isEmpty
                        ? 'Select Category'
                        : _categoryController.text,
                    style: TextStyle(
                      color: _categoryController.text.isEmpty
                          ? Colors.grey
                          : AppPallete.black,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppPallete.gradient2,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppPallete.greyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: AppPallete.gradient2),
                  const SizedBox(width: 12),
                  Text(
                    dateController.text.isEmpty
                        ? 'Select Date'
                        : dateController.text,
                    style: TextStyle(
                      color: dateController.text.isEmpty
                          ? Colors.grey
                          : AppPallete.black,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSubmitButton() {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: ElevatedButton(
        onPressed: uploadTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.gradient2,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: AppPallete.gradient2.withOpacity(0.3),
        ),
        child: const Text(
          'Add Transaction',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
