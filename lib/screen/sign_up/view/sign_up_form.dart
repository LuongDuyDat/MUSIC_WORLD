import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import '../../../components/button.dart';
import '../../../components/input_field.dart';
import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/string.dart';
import '../../../util/text_style.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.1182,),
        Input(icon: 'assets/icons/name_icon.png', hintText: nameString),
        SizedBox(height: screenHeight * 0.044,),
        Input(icon: 'assets/icons/email_icon.png', hintText: emailString),
        SizedBox(height: screenHeight * 0.044,),
        Input(
          icon: 'assets/icons/password_icon.png',
          hintText: passWordString,
          suffixIcon: "assets/icons/show_pass_icon.png",
        ),
        SizedBox(height: screenHeight * 0.079,),
        Button(text: signUPString, radius: 0, onPressed: () {
            Navigate.popPage(context);
          }, minimumSize: screenHeight * 0.0566,
        ),
        SizedBox(height: screenHeight * 0.074,),
        RichText(
            text: TextSpan(
                text: haveAccountString,
                style: bodyRoboto2.copyWith(
                  color: textPrimaryColor,
                ),
                children: [
                  TextSpan(
                    text: signINString,
                    style: bodyRoboto2.copyWith(
                      color: primaryColor,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigate.popPage(context);
                    },
                  )
                ]
            )


        )
      ],
    );
  }
}