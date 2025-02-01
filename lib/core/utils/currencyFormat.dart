import 'package:intl/intl.dart';

String currenctyFormat(double money) {
  return NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(money);
}
