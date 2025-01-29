import 'package:flutter/material.dart';

class DatePickerUseCase {
  Future<DateTime?> pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2010);
    DateTime lastDate = DateTime(2101);

    // Show date picker and return selected date
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }
}
