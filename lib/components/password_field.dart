import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/globals.dart';
import '../util/colors.dart';
import '../util/text_style.dart';

class InputPassword extends StatefulWidget {
  final TextEditingController myController;

  const InputPassword({
    Key? key,
    required this.myController,
  }) : super(key: key)  ;

  @override
  State<StatefulWidget> createState()=>InputPasswordState();

}
class InputPasswordState extends State<InputPassword> {
  final String icon = 'assets/icons/password_icon.png';
  final String hintText = 'password';
  final String suffixIcon = "assets/icons/show_pass_icon.png";
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController myController = widget.myController;
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
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.02, right: 0),
          child: IconButton(
            icon: ImageIcon(
              _passwordVisible? AssetImage("assets/icons/show_pass_icon.png") : AssetImage("assets/icons/dont-show-password.png"),
              color: neutralColor2,
            ),
            padding: EdgeInsets.only(top: screenHeight * 0.016),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          )
        ),
      ),
      obscureText: !_passwordVisible,
      cursorColor: primaryColor,
      style: bodyMontserratMedium2.copyWith(color: textPrimaryColor),
      controller: myController,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'')),
      ],
    );
  }
}