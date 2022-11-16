import 'package:flutter/material.dart';
import 'package:music_world_app/util/string.dart';

import '../../../util/colors.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/text_style.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          padding: EdgeInsets.only(left: 0.0365 * screenWidth),
          icon: const Icon(Icons.arrow_back),
          iconSize: 24,
          onPressed: () {
            Navigate.popPage(context);
          },
        ),
        title: Text(
          editString,
          style: title5.copyWith(color: textPrimaryColor),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 0.02 * screenHeight,),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.064 * screenWidth, 0.1893 * screenWidth , 0.064 * screenWidth, 0),
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(150, 70, 70, 70),
                    ),
                    height: 0.59 * screenHeight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.04267 * screenWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.2 * screenHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userNameString,
                                style: lyric.copyWith(color: neutralColor2),
                              ),
                              Text(
                                account.userName,
                                style: bodyRegular1.copyWith(color: textPrimaryColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.0616 * screenHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                emailString,
                                style: lyric.copyWith(color: neutralColor2),
                              ),
                              Text(
                                account.email,
                                style: bodyRegular1.copyWith(color: textPrimaryColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.0616 * screenHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                phoneString,
                                style: lyric.copyWith(color: neutralColor2),
                              ),
                              Text(
                                account.phone,
                                style: bodyRegular1.copyWith(color: textPrimaryColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.0616 * screenHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                genderString,
                                style: lyric.copyWith(color: neutralColor2),
                              ),
                              Text(
                                account.gender,
                                style: bodyRegular1.copyWith(color: textPrimaryColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.0616 * screenHeight,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateBirthString,
                                style: lyric.copyWith(color: neutralColor2),
                              ),
                              Text(
                                account.dob.toString().substring(0, 10),
                                style: bodyRegular1.copyWith(color: textPrimaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 0.1893 * screenWidth,
                  backgroundColor: neutralColor2,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: Image.asset(
                        account.picture,
                        fit: BoxFit.cover,
                        width: 0.364 * screenWidth,
                        height: 0.364 * screenWidth,
                      ),
                    ),
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.584 * screenWidth, 0.272 * screenWidth, 0, 0),
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 0.0533 * screenWidth,
                  child: const Icon(Icons.camera_alt, size: 24, color: Colors.black,),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.06 * screenHeight,),
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                changePasswordString,
                style: bodyRegular1.copyWith(
                  color: primaryColor,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

}