import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/core/utils/calculate_money.dart';
import 'package:cuanbijak_flutter_uas/core/utils/currencyFormat.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late UserEntity user;
  String _selectedChartType = 'line';
  List<ChartData> _chartData = [];
  bool _showFullBalance = false;
  bool _showMoreDisbursements = false;
  bool _showMoreRecords = false;

  @override
  void initState() {
    super.initState();
    user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    context.read<TransactionBloc>().add(FetchAllTransaction(user.id));
  }

  void _prepareChartData(List<TransactionEntity> transactions) {
    final Map<DateTime, double> data = {};

    for (var transaction in transactions) {
      DateTime key = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);
      final amount = transaction.transactionStatus == 'Income'
          ? transaction.money
          : -transaction.money;

      data.update(key, (value) => value + amount, ifAbsent: () => amount);
    }

    // Convert to ChartData format
    _chartData = data.entries.map((entry) {
      return ChartData(entry.key, entry.value);
    }).toList();
  }

  Widget _buildDisbursementStructure(List<TransactionEntity> transactions) {
    final disbursements = transactions
        .where((t) => t.transactionStatus == 'Disbursement')
        .toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Disbursement Structure',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppPallete.gradient2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'LAST 30 DAYS',
              style: TextStyle(
                fontSize: 14,
                color: AppPallete.greyColor,
              ),
            ),
            const SizedBox(height: 10),
            ...disbursements
                .take(_showMoreDisbursements ? disbursements.length : 3)
                .map((transaction) => ListTile(
                      title: Text(transaction.category),
                      trailing: Text(
                        '-${currenctyFormat(transaction.money, false)}',
                        style: const TextStyle(
                          color: AppPallete.errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
            if (disbursements.length > 3)
              TextButton(
                onPressed: () => setState(
                    () => _showMoreDisbursements = !_showMoreDisbursements),
                child: Text(
                  _showMoreDisbursements ? 'SHOW LESS' : 'SHOW MORE',
                  style: const TextStyle(
                    color: AppPallete.gradient2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastRecordsOverview(List<TransactionEntity> transactions) {
    final lastRecords =
        transactions.take(_showMoreRecords ? transactions.length : 3).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Records Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppPallete.gradient2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'LAST 30 DAYS',
              style: TextStyle(
                fontSize: 14,
                color: AppPallete.greyColor,
              ),
            ),
            const SizedBox(height: 10),
            ...lastRecords.map((transaction) => ListTile(
                  title: Text(transaction.category),
                  subtitle: Text(DateFormat('MMM d').format(transaction.date)),
                  trailing: Text(
                    '${transaction.transactionStatus == 'Income' ? '+' : '-'}${currenctyFormat(transaction.money, false)}',
                    style: TextStyle(
                      color: transaction.transactionStatus == 'Income'
                          ? AppPallete.greenColor700
                          : AppPallete.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            if (transactions.length > 3)
              TextButton(
                onPressed: () =>
                    setState(() => _showMoreRecords = !_showMoreRecords),
                child: Text(
                  _showMoreRecords ? 'SHOW LESS' : 'SHOW MORE',
                  style: const TextStyle(
                    color: AppPallete.gradient2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildChartTypeButton('Line', 'line'),
          _buildChartTypeButton('Bar', 'bar'),
          _buildChartTypeButton('Pie', 'pie'),
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(String label, String value) {
    return GestureDetector(
      onTap: () => setState(() => _selectedChartType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedChartType == value
              ? AppPallete.gradient2
              : AppPallete.greyColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                _selectedChartType == value ? Colors.white : AppPallete.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedChart() {
    switch (_selectedChartType) {
      case 'bar':
        return _buildBarChart();
      case 'pie':
        return _buildPieChart();
      default:
        return _buildLineChart();
    }
  }

  Widget _buildLineChart() {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.MMMd(),
        intervalType: DateTimeIntervalType.days,
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.simpleCurrency(
          locale: 'id',
          name: 'Rp ',
          decimalDigits: 0,
        ),
      ),
      series: [
        LineSeries<ChartData, DateTime>(
          dataSource: _chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          color: AppPallete.gradient2,
          width: 4,
          markerSettings: const MarkerSettings(isVisible: false),
        )
      ],
    );
  }

  Widget _buildBarChart() {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.MMMd(),
        intervalType: DateTimeIntervalType.days,
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.simpleCurrency(
          locale: 'id',
          name: 'Rp ',
          decimalDigits: 0,
        ),
      ),
      series: [
        BarSeries<ChartData, DateTime>(
          dataSource: _chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          color: AppPallete.gradient2,
        )
      ],
    );
  }

  Widget _buildPieChart() {
    final income = _chartData
        .where((data) => data.y > 0)
        .fold(0.0, (sum, data) => sum + data.y);
    final disbursement = _chartData
        .where((data) => data.y < 0)
        .fold(0.0, (sum, data) => sum + data.y);

    return SfCircularChart(
      title: const ChartTitle(
        text: 'Income vs Disbursements',
        textStyle: TextStyle(
          fontSize: 18,
          color: AppPallete.gradient2,
          fontWeight: FontWeight.bold,
        ),
      ),
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: TextStyle(color: AppPallete.black),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries>[
        PieSeries<ChartDataPie, String>(
          dataSource: [
            ChartDataPie('Income', income, AppPallete.greenColor700),
            ChartDataPie(
                'Disbursement', disbursement.abs(), AppPallete.errorColor),
          ],
          xValueMapper: (ChartDataPie data, _) => data.category,
          yValueMapper: (ChartDataPie data, _) => data.value,
          pointColorMapper: (ChartDataPie data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            connectorLineSettings: ConnectorLineSettings(
              type: ConnectorType.curve,
              length: '20%',
            ),
          ),
          explode: true,
          explodeIndex: 0,
          animationDuration: 1000,
          radius: '60%',
          dataLabelMapper: (ChartDataPie data, _) =>
              '${data.category}\n${currenctyFormat(data.value, false)}',
          enableTooltip: true,
          strokeWidth: 2,
          strokeColor: AppPallete.whiteColor,
        )
      ],
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
                  expandedHeight: 175,
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
                              'Balance Trend',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.gradient2,
                              ),
                            ),
                            _buildChartSelector(),
                            SizedBox(
                              height: 300,
                              child: _buildSelectedChart(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // disbursements Structure
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildDisbursementStructure(state.transaction),
                  ),
                ),

                // Last Records Overview
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildLastRecordsOverview(state.transaction),
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
    final totalBalance = calculateTotalMoney(transactions);
    final income = calculateIncome(transactions);
    final disbursement = calculateDisbursement(transactions);

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
                _buildBalanceTile('Total Balance', totalBalance),
                _buildBalanceTile('Income', income),
                _buildBalanceTile('Disbursement', disbursement),
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
        GestureDetector(
          onTap: () => setState(() => _showFullBalance = !_showFullBalance),
          child: Text(
            _showFullBalance
                ? currenctyFormat(amount, false)
                : currenctyFormat(amount, true),
            style: const TextStyle(
              color: AppPallete.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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

double calculateDisbursement(List<TransactionEntity> transactions) {
  return transactions
      .where((t) => t.transactionStatus == 'Disbursement')
      .fold(0, (sum, t) => sum + t.money);
}

class ChartData {
  final DateTime x;
  final double y;
  final String? category;

  ChartData(this.x, this.y, [this.category]);
}

class ChartDataPie {
  final String category;
  final double value;
  final Color color;

  ChartDataPie(this.category, this.value, this.color);
}
