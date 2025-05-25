import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tremor_track/screens/patient_doctor.dart';
import '../component/MyButton.dart';
import '../constants/app_colors.dart';
import 'login.dart';

class IntroPage extends StatelessWidget {
  const IntroPage();

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 260,
              width: 295,
            ),
            const SizedBox(height: 30,),
            const Text(
              'Let\'s detect Parkinson\'s with ease',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 24),
              child: const Text(
                "Tremor Track is designed to assist in detecting potential signs of Parkinson's disease through hand drawing test in less than two minutes by drawing circle, mender or spiral and record voice.",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50,),
            GestureDetector(
              onTap: () => navigateToLogin(context), // Navigate to login page when tapped
              child:  Container(
                width: max(MediaQuery.of(context).size.width - 100, 0), // Ensure width is not negative
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  border: Border.all(
                    color: Color(0xFF458C55), // Border color
                    width: 4, // Border width
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
