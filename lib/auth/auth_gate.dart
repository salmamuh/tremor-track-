// import 'package:tremor2/auth/login_or_register.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../screens/homePage.dart';
// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           //user is logged in
//           if(snapshot.hasData){
//             return  HomePage();
//           }else{
//             //user is not logged in
//             return const LoginOrRegister();
//
//           }
//         },
//       ),
//     );
//   }
// }
