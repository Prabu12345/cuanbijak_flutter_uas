import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class TransactionText extends StatelessWidget {
  final String text;
  final IconData iconText;
  const TransactionText({
    super.key,
    required this.text,
    required this.iconText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          iconText,
          size: 30,
          color: AppPallete.whiteColor,
        ),
        Container(
          margin: const EdgeInsets.only(left: 8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: AppPallete.whiteColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ), // The text
        ),
      ],
    );
  }
}
