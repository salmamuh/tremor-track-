import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
class ChatBubble extends StatelessWidget {
  final String messages;
  final bool isCurrentUser;

  const ChatBubble({super.key, required this.messages, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: isCurrentUser? AppColors.mainColor.withOpacity(0.9):AppColors.mainColor.withOpacity(0.3),borderRadius: BorderRadius.only(topLeft: Radius.circular(32),topRight: Radius.circular(32),bottomRight: Radius.circular(32),bottomLeft:Radius.circular(32) )),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),

      child: Text(messages,style: TextStyle(color: Colors.white),),
    );
  }
}
