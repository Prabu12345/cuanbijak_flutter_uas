import 'package:intl/intl.dart';

String formatDateByDDMMMMYYYY(DateTime date) {
  return DateFormat("dd MMM yyyy").format(date);
}
