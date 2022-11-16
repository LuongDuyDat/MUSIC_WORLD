import 'package:flutter/material.dart';

import '../util/colors.dart';
import '../util/text_style.dart';

class ShowMoreListTile extends StatelessWidget {
  final String title;
  final String icon;
  final String trailing;
  final Function()? onTap;
  const ShowMoreListTile({Key? key, required this.title, required this.icon, required this.trailing, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        horizontalTitleGap: 3,
        leading: ImageIcon(
          AssetImage(icon),
          color: const Color(0xFFEEEEEE),
          size: 20,
        ),
        title: Text(
          title,
          style: bodyRegular1.copyWith(color: textPrimaryColor,),
        ),
        trailing: Icon(
          trailing == "navigate_next" ? Icons.navigate_next : Icons.toggle_on,
          size: trailing == "navigate_next" ? 24 : 30,
          color: trailing == "navigate_next" ? const Color(0xFFEEEEEE) : primaryColor,
        ),
      ),
      onTap: onTap == null ? null : onTap!,
    );
  }

}