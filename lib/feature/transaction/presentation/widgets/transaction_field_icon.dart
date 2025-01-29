import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionFieldIcon extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon hintIcon;
  final bool isObscureText;
  const TransactionFieldIcon(
      {super.key,
      required this.hintText,
      required this.hintIcon,
      required this.controller,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: hintIcon,
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
