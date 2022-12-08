import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_world_app/components/password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_world_app/screen/login/view/login_page.dart';

import '../../../components/button.dart';
import '../../../components/input_field.dart';
import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/string.dart';
import '../../../util/text_style.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorText = "";
  @override
  void initState() {
    errorText = "";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.1182,
            child: Row (
              children: [
                errorText.isNotEmpty?Icon(Icons.error, color: textErrorColor,):const SizedBox(height: 10,),
                Text(
                  errorText,
                  style: TextStyle(color: textErrorColor,),
                  textAlign: TextAlign.center,
                  // overflow: TextOverflow.ellipsis,
                ),
              ],
            )
        ),
        Input(icon: 'assets/icons/name_icon.png', hintText: nameString, controller: nameController,),
        SizedBox(height: screenHeight * 0.044,),
        Input(icon: 'assets/icons/email_icon.png', hintText: emailString, controller: emailController,),
        SizedBox(height: screenHeight * 0.044,),
        InputPassword(myController: passwordController),
        SizedBox(height: screenHeight * 0.079,),
        Button(text: signUPString, radius: 0, onPressed: handleSignUp, minimumSize: screenHeight * 0.0566,
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

  void handleSignUp() {
    if (nameController.text.isEmpty) {
      setState(() {
        errorText = emptyStringError;
      });
      return;
    }
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((value) {
      Navigate.pushPage(context, const LoginPage());
      // final docUser = FirebaseFirestore.instance.collection("users").doc();
      // final newUser = {
      //   'name': Name,
      //   'email': Email,
      //   'password': Password,
      // };
      // await docUser.set(newUser);
    }).onError((error, stackTrace) {
      String tmp = error.toString();
      print(tmp);
      tmp = tmp.substring(tmp.indexOf(']') + 1);
      int id = 0;
      for (int i = 1; i < tmp.length; i++) {
        if (tmp.substring(i, i+1) == tmp.substring(i, i+1).toUpperCase()) {
          id = i;
          break;
        }
      }
      tmp = tmp.substring(id);
      switch (tmp) {
        case 'Given String is empty or null':
          errorText = emptyStringError; break;
        case 'The email address is badly formatted.':
          errorText = badFormatError; break;
        case 'Password should be at least 6 characters':
          errorText = atleastLenPwError; break;
        case 'The email address is already in use by another account.':
          errorText = emailUsedError; break;
        default:
          errorText = defaultError;
      }
      setState(() {});
    });
  }
}