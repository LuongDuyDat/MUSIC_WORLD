import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_world_app/components/password_field.dart';
import 'package:music_world_app/screen/home/view/home_page.dart';
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


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  String errorText = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    errorText = "";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        //show error
        SizedBox (
            height: screenHeight * 0.086,
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

        Input(
          icon: "assets/icons/email_icon.png",
          hintText: emailString,
          controller: emailController,
        ),
        SizedBox(height: screenHeight * 0.044,),
        InputPassword(myController: passwordController),
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
        Button(text: signInString, radius: 0, onPressed: handleSignIn
          , minimumSize: screenHeight * 0.0566,),
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

  void handleSignIn() {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text,
        password: passwordController.text)
        .then((value) {
      Navigate.pushPage(context, const EnterPhonePage());
    }).onError((error, stackTrace) {
      setState(() {
        String tmp = error.toString();
        tmp = tmp.substring(tmp.indexOf(']') + 2);
        // print(tmp);
        switch (tmp) {
          case 'Given String is empty or null':
            errorText = emptyStringError;
            break;
          case 'The email address is badly formatted.':
            errorText = badFormatError;
            break;
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorText = notRegisteredError;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorText = incorrectPasswordError;
            break;
          default:
            errorText = defaultError;
        }
      });
    });
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
              onTap: () {
                signInWithGoogle(context);
              },
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

  void signInWithGoogle(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    // GoogleSignInAccount? _user;
    googleSignIn.signOut();

    final googleUser = await googleSignIn.signIn(); //option only for android
    if (googleUser == null) return;
    // _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      Navigate.pushPage(context, const EnterPhonePage());
    });
  }
}