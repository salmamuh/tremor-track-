// import 'package:flutter/material.dart';
// class MyTextField extends StatelessWidget {
//   final String hintText;
//   final bool obsecure;
//   final TextEditingController controller;
//   const MyTextField({super.key, required this.hintText, required this.obsecure, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       obscureText: obsecure,
//       controller: controller,
//       decoration: InputDecoration(
//
//         label:  Text(hintText),
//         hintText: hintText,
//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.grey),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Colors.black,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Colors.red,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }
