import 'package:flutter/material.dart';

import 'package:tremor_track/constants/app_colors.dart';
import 'package:tremor_track/screens/hand_drawn_test.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Divider(
          color: AppColors.mainColor,
          thickness: 1.7,
          indent: 8,
          endIndent: 8,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Text(
              'or',
              style: TextStyle(color:AppColors.mainColor,fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}