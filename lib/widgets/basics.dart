import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/theme_data.dart';

simpleAppBar(theme theme, {required String text, BuildContext? context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (context != null)
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              "assets/icons/back.svg",
              width: 20,
              color: theme.textColor,
            ),
          ),
        ),
      Flexible(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: theme.textColor,
            ),
            softWrap: true,
          ),
        ),
      ),
      SizedBox(width: 45),
    ],
  );
}
