import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final int w;
  const CustomButtonAuth({super.key, this.onPressed, required this.title, required this.w});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: max(MediaQuery.of(context).size.width -w, 0), // Ensure width is not negative
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          border: Border.all(
            color: const Color(0xFF458C55), // Border color
            width: 4, // Border width
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
}}