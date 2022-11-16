import 'package:flutter/material.dart';

import '../util/colors.dart';
import '../util/text_style.dart';

class Button extends StatelessWidget {
  final String text;
  final double radius;
  final Function? onPressed;
  final double minimumSize;
  final TextStyle? type;

  const Button ({
    Key? key,
    required this.text,
    required this.radius,
    this.onPressed,
    required this.minimumSize,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.fromHeight(minimumSize),
        primary: const Color(0xFF20242F),
        backgroundColor: primaryColor,
        textStyle: type ?? bodyMedium1,
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Text(text),
    );
  }
}