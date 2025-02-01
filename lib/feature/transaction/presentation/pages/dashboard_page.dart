import 'dart:math';
import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/calculate_money.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late UserEntity user;
  String _selectedChart = 'monthly'; // 'weekly', 'monthly', 'yearly'
  List<FlSpot> _chartData = [];

  @override
  void initState() {
    super.initState();
    user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    context.read<TransactionBloc>().add(FetchAllTransaction(user.id));
  }

  void _prepareChartData(List<TransactionEntity> transactions) {
    final Map<DateTime, double> data = {};

    for (var transaction in transactions) {
      DateTime key;
      switch (_selectedChart) {
        case 'weekly':
          key = DateTime(transaction.date.year, transaction.date.month,
              transaction.date.day - transaction.date.weekday);
          break;
        case 'monthly':
          key = DateTime(transaction.date.year, transaction.date.month);
          break;
        case 'yearly':
          key = DateTime(transaction.date.year);
          break;
        default:
          key = DateTime(transaction.date.year, transaction.date.month);
      }

      final amount = transaction.transactionStatus == 'Income'
          ? transaction.money
          : -transaction.money;

      data.update(key, (value) => value + amount, ifAbsent: () => amount);
    }

    // Convert to FLSpot format
    _chartData = data.entries.map((entry) {
      return FlSpot(
        entry.key.millisecondsSinceEpoch.toDouble(),
        entry.value,
      );
    }).toList();
  }

  Widget _buildFinancialChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                String text;
                switch (_selectedChart) {
                  case 'weekly':
                    text = 'Week ${date.day ~/ 7 + 1}';
                    break;
                  case 'monthly':
                    text = DateFormat.MMM().format(date);
                    break;
                  case 'yearly':
                    text = date.year.toString();
                    break;
                  default:
                    text = DateFormat.MMM().format(date);
                }
                return Text(text);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('\$${value.toInt()}');
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: _chartData,
            isCurved: true,
            color: AppPallete.gradient2,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: AppPallete.gradient2.withOpacity(0.3),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
        minX: _chartData.isNotEmpty
            ? _chartData.map((s) => s.x).reduce((a, b) => min(a, b))
            : 0,
        maxX: _chartData.isNotEmpty
            ? _chartData.map((s) => s.x).reduce((a, b) => max(a, b))
            : 0,
        minY: _chartData.isNotEmpty
            ? _chartData.map((s) => s.y).reduce((a, b) => min(a, b))
            : 0,
        maxY: _chartData.isNotEmpty
            ? _chartData.map((s) => s.y).reduce((a, b) => max(a, b))
            : 0,
      ),
    );
  }

  Widget _buildChartSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildChartTypeButton('Weekly', 'weekly'),
          _buildChartTypeButton('Monthly', 'monthly'),
          _buildChartTypeButton('Yearly', 'yearly'),
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(String label, String value) {
    return GestureDetector(
      onTap: () => setState(() => _selectedChart = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedChart == value
              ? AppPallete.gradient2
              : AppPallete.greyColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _selectedChart == value ? Colors.white : AppPallete.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
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
          _prepareChartData(state.transaction);

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // Header Section
                SliverAppBar(
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildUserHeader(state.transaction),
                  ),
                ),

                // Chart Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Financial Overview',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.gradient2,
                              ),
                            ),
                            _buildChartSelector(),
                            SizedBox(
                              height: 250,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildFinancialChart(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Recent Transactions
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final transaction = state.transaction[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TransactionCard(transactions: transaction),
                        );
                      },
                      childCount: state.transaction.length > 4
                          ? 4
                          : state.transaction.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUserHeader(List<TransactionEntity> transactions) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppPallete.gradient2, AppPallete.gradient1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: AppPallete.gradient2,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: AppPallete.whiteColor.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: AppPallete.whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBalanceTile(
                    'Total Balance', calculateTotalMoney(transactions)),
                _buildBalanceTile('Income', calculateIncome(transactions)),
                _buildBalanceTile('Expense', calculateExpense(transactions)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceTile(String title, double amount) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppPallete.whiteColor.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppPallete.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Helper functions
double calculateIncome(List<TransactionEntity> transactions) {
  return transactions
      .where((t) => t.transactionStatus == 'Income')
      .fold(0, (sum, t) => sum + t.money);
}

double calculateExpense(List<TransactionEntity> transactions) {
  return transactions
      .where((t) => t.transactionStatus == 'Disbursement')
      .fold(0, (sum, t) => sum + t.money);
}
