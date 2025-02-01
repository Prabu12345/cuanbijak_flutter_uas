import 'package:intl/intl.dart';

String currenctyFormat(double money, bool isShort) {
  String symbol = 'Rp ';

  if (isShort) {
    if (money >= 1e9) {
      return '$symbol${(money / 1e9).toStringAsFixed(1)}B'; // Billion
    } else if (money >= 1e6) {
      return '$symbol${(money / 1e6).toStringAsFixed(1)}M'; // Million
    } else if (money >= 1e3) {
      return '$symbol${(money / 1e3).toStringAsFixed(0)}K'; // Thousand
    } else {
      return symbol + money.toString();
    }
  } else {
    return NumberFormat.currency(
      locale: 'id',
      symbol: symbol,
      decimalDigits: 0,
    ).format(money);
  }
}
