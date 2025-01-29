import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class TransactionField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isEnable;
  final bool isObscureText;
  const TransactionField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isEnable = true,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnable,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppPallete.black38,
        ),
        filled: true,
        fillColor: AppPallete.whiteColor,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
