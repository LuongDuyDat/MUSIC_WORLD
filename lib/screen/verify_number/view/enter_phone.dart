import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_world_app/util/navigate.dart';
import 'package:music_world_app/util/colors.dart';

import '../../../components/button.dart';
import '../../../util/globals.dart';
import '../../../util/string.dart';
import '../../../util/text_style.dart';
import 'otp_verify.dart';


class EnterPhonePage extends StatelessWidget {
  const EnterPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigate.popPage(context);
          },
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.06, top: screenHeight * 0.0345),
              child: SizedBox(
                width: screenWidth * 0.6587,
                child: Text(
                  enterPhoneNumberString,
                  style: titleMedium3.copyWith(
                    color: textPrimaryColor,
                    height: 1.3,
                  ),
                ),
              )

          ),

          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.14267,
              right: screenWidth * 0.14267,
              top: screenHeight * 0.11576,),
            child: Column(
              children: [
                TextField(
                    decoration: InputDecoration(
                      hintText: phoneString,
                      hintStyle: bodyMontserratMedium2.copyWith(
                          color: neutralColor2),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.0644),
                        child: ImageIcon(
                          AssetImage("assets/icons/phone_icon.png"),
                          color: neutralColor2,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(
                          top: screenHeight * 0.016),
                    ),
                    cursorColor: primaryColor,
                    keyboardType: TextInputType.phone,
                    style: bodyMontserratMedium2.copyWith(
                        color: textPrimaryColor),
                    controller: phoneController,
                ),
                SizedBox(height: screenHeight * 0.0813,),
                Button(
                  text: continueString,
                  radius: 0,
                  onPressed: () {
                    verifyPhone(context, phoneController.text);
                  },
                  minimumSize: screenHeight * 0.0566,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void verifyPhone(BuildContext context, String phoneNum) async {
    Navigate.pushPage(context, const Otp(verificationId: "123456",));
    phoneNum = '+84' + phoneNum.substring(1);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) {
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          Navigate.pushPage(context, Otp(verificationId: verificationId,));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}
