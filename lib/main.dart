import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tremor_track/screens/firstPage.dart';
import 'package:tremor_track/screens/splashScreen.dart';
import 'package:tremor_track/screens/Intro.dart';
import 'package:tremor_track/screens/wallet.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAppCheck.instance.activate();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
