import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_world_app/util/globals.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/string.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../components/button.dart';
import '../../../components/input_field.dart';
import '../../forget_pass/view/forget_pass_page.dart';
import '../../sign_up/view/sign_up_page.dart';
import '../../verify_number/view/enter_phone.dart';


class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.086,),
        Input(
          icon: "assets/icons/email_icon.png",
          hintText: emailString,
        ),
        SizedBox(height: screenHeight * 0.044,),
        Input(
          icon: "assets/icons/password_icon.png",
          hintText: passWordString,
          suffixIcon: "assets/icons/show_pass_icon.png",
        ),
        SizedBox(height: screenHeight * 0.044,),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Navigate.pushPage(context, const ForgotPassPage());
            },
            child: Text(
              forgotPassString,
              style: bodyMontserratMedium2.copyWith(color: textPrimaryColor),
            ),
          )
        ),
        SizedBox(height: screenHeight * 0.0776,),
        Button(text: signInString, radius: 0, onPressed: () {
          Navigate.pushPage(context, const EnterPhonePage());
        }, minimumSize: screenHeight * 0.0566,),
        SizedBox(height: screenHeight * 0.165,),
        const SignInWithButtons(),
        SizedBox(height: screenHeight * 0.074,),
        RichText(
            text: TextSpan(
                text: doNotHaveAccountString,
                style: bodyRoboto2.copyWith(
                  color: textPrimaryColor,
                ),
                children: [
                  TextSpan(
                    text: signUpString,
                    style: bodyRoboto2.copyWith(
                      color: primaryColor,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigate.pushPage(context, const SignUpPage());
                    },
                  )
                ]
            )


        ),
      ],
    );
  }

}

class SignInWithButtons extends StatelessWidget {
  const SignInWithButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: screenWidth * 0.221,
                height: screenHeight / 812,
                decoration: const BoxDecoration(
                  color: Color(0xFF8D92A3),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Text(
                connectWithString,
                style: bodyRegular3.copyWith(
                  color: const Color(0xFF8D92A3),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: screenWidth * 0.221,
                height: screenHeight / 812,
                decoration: const BoxDecoration(
                  color: Color(0xFF8D92A3),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.0246,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/icons/facebook.png",
                width: screenWidth * 0.1064,
                height: screenWidth * 0.1064,
              ),
            ),
            SizedBox(width: screenWidth * 0.032,),
            InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/icons/google-plus.png",
                width: screenWidth * 0.1064,
                height: screenWidth * 0.1064,
              ),
            ),
            SizedBox(width: screenWidth * 0.032,),
            InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/icons/twitter.png",
                width: screenWidth * 0.1064,
                height: screenWidth * 0.1064,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
