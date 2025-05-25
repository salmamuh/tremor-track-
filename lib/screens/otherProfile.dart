import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tremor_track/component/text_box.dart';

import '../constants/app_colors.dart';

class ProfilePage2 extends StatefulWidget {
  final String rUser;

  const ProfilePage2({Key? key,required this.rUser}) : super(key: key);

  @override
  State<ProfilePage2> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage2> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users'); // Updated collection reference



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      appBar: AppBar(
        title: Text("Profile Page",style: TextStyle( color: Colors.white,),),
        backgroundColor: AppColors.mainColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back button here
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(widget.rUser).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                SizedBox(height: 50),
                Icon(Icons.person, size: 72, color: AppColors.mainColor),
                SizedBox(height: 10),
                Text(
                  userData['email'],
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
                      fontSize: 17,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Name'),
                  subtitle: Text(userData['name'] ?? 'Not provided'),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text('About'),
                  subtitle: Text(userData['description'] ?? 'Not provided'),
                  leading: Icon(Icons.info_outline),
                ),
                ListTile(
                  title: Text('Phone'),
                  subtitle: Text(userData['phone'] ?? 'Not provided'),
                  leading: Icon(Icons.phone),
                ),
                ListTile(
                  title: Text('Address'),
                  subtitle: Text(userData['address'] ?? 'Not provided'),
                  leading: Icon(Icons.home_work),
                ),
                ListTile(
                  title: Text('Age'),
                  subtitle: Text(userData['age'] != null ? userData['age'].toString() : 'Not provided'),
                  leading: Icon(Icons.calendar_today),
                ),
                ListTile(
                  title: Text('Gender'),
                  subtitle: Text(userData['gender'] ?? 'Not provided'),
                  leading: Icon(Icons.person_outline),
                ),
                SizedBox(height: 50),

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