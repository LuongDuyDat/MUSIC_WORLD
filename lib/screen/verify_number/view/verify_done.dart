import 'package:flutter/material.dart';
import 'package:music_world_app/screen/home.dart';

import '../../../components/button.dart';
import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/string.dart';
import '../../../util/text_style.dart';

class VerifyDonePage extends StatelessWidget {
  const VerifyDonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only( top: screenHeight * 0.1765),
              child: Center(
                child: Text(
                  verifyDoneString,
                  style: titleMedium3.copyWith(
                    color: textPrimaryColor,
                    height: 1.3,
                  ),
                ),
              )

          ),
          SizedBox(height: screenHeight * 0.013547,),
          Center(
            child: SizedBox(
              width: screenWidth * 0.4 ,
              child: Text(
                haveGoodExperienceString,
                style: bodyRoboto2.copyWith(
                  color: textPrimaryColor,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.14267,right: screenWidth * 0.14267, top: screenHeight * 0.1,),
            child: Button(
              text: doneString,
              radius: 0,
              onPressed: () {
                Navigate.pushPage(context, const MyHomePage());
              },
              minimumSize: screenHeight * 0.0566,
            ),
          ),
        ],
      ),
    );
  }

}