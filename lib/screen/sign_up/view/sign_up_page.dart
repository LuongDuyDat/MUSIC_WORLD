import 'package:flutter/material.dart';
import 'package:music_world_app/screen/sign_up/view/sign_up_form.dart';

import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/string.dart';
import '../../../util/text_style.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/sign_up.png"),
                fit: BoxFit.cover,
              )
          ),
        ),
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
            body: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.1067, right: screenWidth * 0.1067, top: screenHeight * 0.127),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signUPString,
                    style: title2.copyWith(color: textPrimaryColor),
                  ),
                  const SignUpForm(),
                ],
              ),
            )
        )
      ],
    );
  }
}