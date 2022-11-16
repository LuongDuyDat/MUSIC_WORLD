import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/globals.dart';
import '../util/colors.dart';
import '../util/text_style.dart';

class Input extends StatelessWidget {
  final String icon;
  final String hintText;
  final String? suffixIcon;
  final TextInputFormatter? textInputFormatter;

  const Input({
    Key? key,
    required this.icon,
    required this.hintText,
    this.suffixIcon,
    this.textInputFormatter,
  }) : super(key: key)  ;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: bodyMontserratMedium2.copyWith(color: neutralColor2),
        prefixIcon: Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.0644),
          child: ImageIcon(
            AssetImage(icon),
            color: neutralColor2,
          ),
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02, right: 0),
              child: ImageIcon(
                AssetImage(suffixIcon!),
                color: neutralColor2,
              ),
            ) : const SizedBox(width: 0, height: 0),
        contentPadding: EdgeInsets.only(top: screenHeight * 0.016),
      ),
      cursorColor: primaryColor,
      style: bodyMontserratMedium2.copyWith(color: textPrimaryColor),
      inputFormatters: [
        textInputFormatter != null ? textInputFormatter! : FilteringTextInputFormatter.deny(RegExp(r'')),
      ],
    );
  }

}