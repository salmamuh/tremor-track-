import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
   final void Function()?onPressed;
  const MyTextBox({super.key, required this.text, required this.sectionName,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: AppColors.mainColor.withOpacity(0.9),borderRadius: BorderRadius.circular(8)),
    padding: EdgeInsets.only(left: 15,bottom: 15),
    margin: EdgeInsets.only(left: 20.0,right: 20,top: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(sectionName,style: TextStyle(color: Colors.white,fontSize: 15),),
            IconButton(onPressed: onPressed, icon: Icon(Icons.settings,color: Colors.white,))
          ],
        ),
        Text(text,style: TextStyle(color: Colors.white70),)
      ],
    ),);
  }
}