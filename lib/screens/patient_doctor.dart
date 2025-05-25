// import 'package:flutter/material.dart';
// import 'package:tremor_track/screens/login.dart';
// import 'package:tremor_track/screens/signUp.dart';
//
// import '../constants/app_colors.dart';
//
// bool isDoctor = false; // Global variable
//
// class PatientDoctor extends StatelessWidget {
//   const PatientDoctor ();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             width: 160,
//             child: Image.asset("assets/logo.png"),
//           ),
//           GestureDetector(
//             onTap: () {
//               isDoctor = false;
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SignUpPage(isDoctor: isDoctor),
//                 ),
//               );
//             },
//             child: Container(
//               width: MediaQuery.of(context).size.width - 240,
//               alignment: Alignment.center,
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
//               decoration: BoxDecoration(
//                 color: AppColors.mainColor,
//                 border: Border.all(
//                   color: Color(0xFF458C55), // Border color
//                   width: 4, // Border width
//                 ),
//                 borderRadius: BorderRadius.circular(40),
//               ),
//               child: Text(
//                 "Patient",
//                 style: TextStyle(color: Colors.white, fontSize: 15),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               isDoctor = true;
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SignUpPage(isDoctor: isDoctor),
//                 ),
//               );
//             },
//             child: Container(
//               width: MediaQuery.of(context).size.width - 240,
//               alignment: Alignment.center,
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
//               decoration: BoxDecoration(
//                 color: AppColors.mainColor,
//                 border: Border.all(
//                   color: Color(0xFF458C55), // Border color
//                   width: 4, // Border width
//                 ),
//                 borderRadius: BorderRadius.circular(40),
//               ),
//               child: Text(
//                 "Doctor",
//                 style: TextStyle(color: Colors.white, fontSize: 15),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
