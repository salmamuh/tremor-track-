import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
class UserTile extends StatelessWidget {
  final String text;
  final void Function()?ontap;
  const UserTile({super.key, required this.text, this.ontap});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 61,
        decoration: BoxDecoration(
            color: AppColors.mainColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12)
        ),
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 20,),
            Text(text)
          ],
        ),
      ),
    );
  }
}