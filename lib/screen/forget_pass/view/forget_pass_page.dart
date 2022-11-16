import 'package:flutter/material.dart';

import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/string.dart';
import '../../../util/text_style.dart';
import 'forget_pass_form.dart';

class ForgotPassPage extends StatelessWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          iconTheme: IconThemeData(
            color: neutralColor1,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,),
            onPressed: () {
              Navigate.popPage(context);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.06, top: screenHeight * 0.0345),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      forgotPassString,
                      style: titleMedium3.copyWith(
                        color: textPrimaryColor,
                      ),
                    ),
                    SizedBox(width: 0, height: screenHeight * 0.033,),
                    SizedBox(
                      width: screenWidth * 0.63,
                      child: Text(
                        passDescription,
                        style: bodyRegular3.copyWith(
                          color: const Color(0xFF8D92A3),
                          height: 2,
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.1067,right: screenWidth * 0.1067, top: screenHeight * 0.1416,),
              child: const ForgotPassForm(),
            ),
          ],
        )
    );
  }

}