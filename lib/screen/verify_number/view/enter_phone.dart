import 'package:flutter/material.dart';
import 'package:music_world_app/components/input_field.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigate.popPage(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.06, top: screenHeight * 0.0345),
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
              padding: EdgeInsets.only(left: screenWidth * 0.14267,right: screenWidth * 0.14267, top: screenHeight * 0.11576,),
              child: Column(
                children: [
                  Input(
                    icon: "assets/icons/phone_icon.png",
                    hintText: phoneString,
                  ),
                  SizedBox(height: screenHeight * 0.0813,),
                  Button(
                    text: continueString,
                    radius: 0,
                    onPressed: () {
                      Navigate.pushPage(context, const Otp());
                    },
                    minimumSize: screenHeight * 0.0566,
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
