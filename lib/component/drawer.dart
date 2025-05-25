// import 'package:flutter/material.dart';
// import 'package:tremor2/component/my_list_tile.dart';
//
// class MyDrawer2 extends StatelessWidget {
//   final void Function()? onProfileTap;
//   final void Function()? onSignOut;
//   const MyDrawer2({super.key,required this.onProfileTap,required this.onSignOut});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Color.fromARGB(255, 11, 12, 63),
//       child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [Column(children: [
//         DrawerHeader(child: Icon(Icons.person,color: Colors.white,size: 64,),
//         ),
//         MyListTile(icon: Icons.home, text: "H O M E",
//         onTap: () => Navigator.pop(context),),
//         MyListTile(icon: Icons.person, text: "P R O F I L E", onTap: onProfileTap )
//       ],)
//         ,
//         Padding(
//           padding: const EdgeInsets.only(bottom: 25.0),
//           child: MyListTile(icon: Icons.logout, text: "L O G O U T", onTap: () {
//                   Navigator.of(context) .pushReplacementNamed("login");
//                  }, ),
//         )
//
//       ],),
//     );
//   }
// }