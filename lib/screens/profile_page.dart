// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:tremor2/component/text_box.dart';
// //
// // import '../component/text_box.dart';
// //
// // class ProfilePage extends StatefulWidget {
// //   const ProfilePage({super.key});
// //
// //   @override
// //   State<ProfilePage> createState() => _ProfilePageState();
// // }
// //
// // class _ProfilePageState extends State<ProfilePage> {
// //   final currentUser=FirebaseAuth.instance.currentUser!;
// //   final usersCollection=FirebaseFirestore.instance.collection('Users');
// //   Future<void>editField(String field)async{
// //        String newValue="";
// //        await showDialog(context: context, builder: (context)=>AlertDialog(backgroundColor: Colors.white,
// //         title: Text("Edit $field",
// //        style: TextStyle(color: Colors.green),),
// //        content: TextField(autofocus: true,style: TextStyle(color: Colors.black),
// //        decoration: InputDecoration(hintText: "Enter new $field",
// //        hintStyle: TextStyle(color: Color.fromARGB(255, 8, 4, 49))),onChanged: (value) {
// //          newValue=value;
// //        },
// //        ),
// //        actions: [
// //         TextButton(onPressed: ()=>Navigator.pop(context), child: Text('cancel',style: TextStyle(color: Colors.black),))
// //         ,TextButton(onPressed: ()=>Navigator.pop(newValue as BuildContext), child: const Text('save',style: TextStyle(color: Colors.black),))
// //        ],),);
// //        if(newValue.trim().length>0){
// //         await usersCollection.doc(currentUser.email).update({field:newValue});
// //        }
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(backgroundColor: Colors.grey[300],
// //       appBar: AppBar(title: Text("Profile Page"),
// //     backgroundColor: Color.fromARGB(255, 5, 32, 63),),
// //     body: StreamBuilder<DocumentSnapshot>(stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
// //       builder: (context, snapshot){
// //       if(snapshot.hasData){
// //         final userData=snapshot.data!.data() as Map<String,dynamic>;
// //         return ListView(children: [const SizedBox(height: 50,),
// //
// //       Icon(Icons.person,size: 72,),
// //       const SizedBox(height: 10,),
// //       Text(currentUser.email!,textAlign: TextAlign.center,
// //       style: TextStyle(color: Color.fromARGB(255, 5, 26, 55),fontSize: 17),
// //       ),const SizedBox(height: 50,),
// //       Padding(
// //         padding: const EdgeInsets.only(left: 25.0),
// //         child: Text("My Details",style: TextStyle(color: const Color.fromARGB(255, 3, 28, 49),fontSize: 17),),
// //       )
// //       ,MyTextBox(text: userData['username'], sectionName: 'Username',onPressed:()=>editField("username")) ,
// //       MyTextBox(text: userData['Phone'], sectionName: 'Phone',onPressed:()=>editField("Phone")),
// //       MyTextBox(text: userData['Birthday'], sectionName: 'Birthday',onPressed:()=>editField("Birthday")) ,
// //       MyTextBox(text: userData['Gender'], sectionName: 'Gender',onPressed:()=>editField("Gender")),
// //       const SizedBox(height: 50,),
// //
// //     ]);
// //       }else if(snapshot.hasError){
// //         return Center(child: Text("Error ${snapshot.error}"));
// //       }
// //       return const Center(child: CircularProgressIndicator(),);
// //     },)
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:doc3_3/component/text_box.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final currentUser = FirebaseAuth.instance.currentUser!;
//   final usersCollection = FirebaseFirestore.instance.collection('Users');
//
//   Future<void> editField(String field) async {
//     String newValue = "";
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         title: Text(
//           "Edit $field",
//           style: TextStyle(color: Colors.white),
//         ),
//         content: TextField(
//           autofocus: true,
//           style: TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: "Enter new $field",
//             hintStyle: TextStyle(color: Colors.indigo),
//           ),
//           onChanged: (value) {
//             newValue = value;
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel', style: TextStyle(color: Colors.black)),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, newValue),
//             child: const Text('Save', style: TextStyle(color: Colors.black)),
//           )
//         ],
//       ),
//     );
//     if (newValue.trim().isNotEmpty) {
//       await usersCollection
//           .doc(currentUser.uid) // Use UID instead of email
//           .update({field: newValue});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         title: Text("Profile Page"),
//         backgroundColor: Colors.indigo,
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: usersCollection.doc(currentUser.uid).snapshots(), // Fetch document using UID
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final userData = snapshot.data!.data() as Map<String, dynamic>;
//             return ListView(
//               children: [
//                 SizedBox(height: 50),
//                 Icon(Icons.person, size: 72,color: Colors.indigo,),
//                 SizedBox(height: 10),
//                 Text(
//                   currentUser.email!,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.indigo,
//                     fontSize: 17,
//                   ),
//                 ),
//                 SizedBox(height: 50),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: Text(
//                     "My Details",
//                     style: TextStyle(
//                       color: Colors.indigo,
//                       fontSize: 17,
//                     ),
//                   ),
//                 ),
//                 MyTextBox(
//                   text: userData['name'],
//                   sectionName: 'name',
//                   onPressed: () => editField("name"),
//                 ),
//                 // MyTextBox(
//                 //   text: userData['Phone'],
//                 //   sectionName: 'Phone',
//                 //   onPressed: () => editField("Phone"),
//                 // ),
//                 // MyTextBox(
//                 //   text: userData['Birthday'],
//                 //   sectionName: 'Birthday',
//                 //   onPressed: () => editField("Birthday"),
//                 // ),
//                 // MyTextBox(
//                 //   text: userData['Gender'],
//                 //   sectionName: 'Gender',
//                 //   onPressed: () => editField("Gender"),
//                 // ),
//                 SizedBox(height: 50),
//               ],
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error ${snapshot.error}"));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tremor_track/component/text_box.dart';

import '../constants/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users'); // Updated collection reference

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Edit $field",
          style: TextStyle(color: Colors.black), // Fixed text color
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.black), // Fixed text color
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: AppColors.mainColor),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.black)), // Fixed text color
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, newValue),
            child: const Text('Save', style: TextStyle(color: Colors.black)), // Fixed text color
          )
        ],
      ),
    );
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white),
        ),iconTheme: IconThemeData(
        color: Colors.white, // Set the color of the back button here
      ),
        backgroundColor: AppColors.mainColor,

      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                SizedBox(height: 50),
                Icon(Icons.person, size: 72, color: AppColors.mainColor),
                SizedBox(height: 10),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My Details",
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 18,

                    ),
                  ),
                ),
                MyTextBox(

                  text: userData['name'] ?? '', // Handle null value
                  sectionName: 'Name',
                  onPressed: () => editField("name"),
                ),
                MyTextBox(
                  text: userData['phone'] ?? '', // Handle null value
                  sectionName: 'Phone',
                  onPressed: () => editField("phone"),
                ),
                MyTextBox(
                  text: userData['age'] ?? '', // Handle null value
                  sectionName: 'Age',
                  onPressed: () => editField("age"),
                ),
                MyTextBox(
                  text: userData['gender'] ?? '', // Handle null value
                  sectionName: 'Gender',
                  onPressed: () => editField("gender"),
                ),
                SizedBox(height: 50),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


