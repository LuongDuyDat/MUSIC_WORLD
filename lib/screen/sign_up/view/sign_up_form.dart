import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:music_world_app/components/password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.1182,),
        Input(icon: 'assets/icons/name_icon.png', hintText: nameString, controller: nameController,),
        SizedBox(height: screenHeight * 0.044,),
        Input(icon: 'assets/icons/email_icon.png', hintText: emailString, controller: emailController,),
        SizedBox(height: screenHeight * 0.044,),
        InputPassword(myController: passwordController),
        SizedBox(height: screenHeight * 0.079,),
        Button(text: signUPString, radius: 0, onPressed: () {
            // Navigate.popPage(context);
            createUser(Name: nameController.text, Email: emailController.text, Password: passwordController.text, context: context);
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

  void createUser({required String Name, required String Email, required String Password, required BuildContext context}) async {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email, password: Password)
      .then((value) {
        print("Created new account");
        Navigate.popPage(context);
        // final docUser = FirebaseFirestore.instance.collection("users").doc();
        // final newUser = {
        //   'name': Name,
        //   'email': Email,
        //   'password': Password,
        // };
        // await docUser.set(newUser);
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }
}