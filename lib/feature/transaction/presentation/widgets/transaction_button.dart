import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class TransactionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String textButton;
  final Color backgroundColor;
  final Color foregroundColor;
  final Size? buttonSize;
  const TransactionButton({
    super.key,
    required this.onPressed,
    required this.textButton,
    this.buttonSize,
    this.backgroundColor = AppPallete.gradient2,
    this.foregroundColor = AppPallete.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: buttonSize,
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
        ),
        child: Text(
          textButton,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
