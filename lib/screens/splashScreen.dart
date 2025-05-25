import 'package:flutter/material.dart';

import 'Intro.dart';
import 'firstPage.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulate a delay for splash screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => IntroPage(),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE), // Set your desired background color
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Image.asset(
          //   'assets/splash_image.jpg', // Replace 'splash_image.jpg' with your image asset
          //   fit: BoxFit.cover,
          // ),
          Positioned(
            // Positioned widget allows you to position its child widget
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/logo.png',height:200,width: 250,),
            ),
          ),
        ],
      ),
    );
  }
}
