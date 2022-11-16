import 'package:flutter/material.dart';

import '../util/colors.dart';
import '../util/text_style.dart';

class ImageType extends StatelessWidget {
  final String asset;
  final String type;
  final double width;
  final double height;
  final Function() onTap;
  const ImageType({
    Key? key,
    required this.asset,
    required this.type,
    required this.width,
    required this.height,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: [
          Image.asset(asset, width: width, height: height, fit: BoxFit.cover,),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                type,
                style: labelMedium1.copyWith(
                  color: textPrimaryColor,
                  shadows: [
                    const Shadow(
                      color: Colors.black,
                      blurRadius: 20,
                      offset: Offset(8.0, 8.0),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

}