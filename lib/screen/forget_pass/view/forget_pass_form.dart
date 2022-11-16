import 'package:flutter/cupertino.dart';
import 'package:music_world_app/components/button.dart';

import '../../../components/button.dart';
import '../../../components/input_field.dart';
import '../../../util/globals.dart';
import '../../../util/string.dart';

class ForgotPassForm extends StatelessWidget {
  const ForgotPassForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Input(icon: 'assets/icons/email_icon.png', hintText: emailString),
        SizedBox(height: screenHeight * 0.0788,),
        Button(text: sentString, radius: 0, minimumSize: screenHeight * 0.0566),
      ],
    );
  }

}