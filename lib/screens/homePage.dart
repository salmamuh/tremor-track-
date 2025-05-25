
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tremor_track/auth/auth_service.dart';
import 'package:tremor_track/component/my_drawer.dart';
import 'package:tremor_track/constants/app_colors.dart';
import 'package:tremor_track/screens/signUp.dart';
import 'package:tremor_track/services/chat/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/search2.dart';
import '../component/userTile.dart';
import 'ChatPage.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(
          'TREMOR TRACK',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the drawer icon here
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          backgroundColor: AppColors.mainColor.withOpacity(0.9),
          child: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          },
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return FutureBuilder(
      future: _chatService.getUsersStream(),
      builder: (context, AsyncSnapshot<Stream<List<Map<String, dynamic>>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading..');
        }

        return StreamBuilder(
          stream: snapshot.data,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading..');
            }

            return ListView(
              children: (snapshot.data as List<Map<String, dynamic>>)
                  .map<Widget>((userData) => _buildUserListItem(userData, context))
                  .toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['name'],
        ontap: () async {
          QuerySnapshot querySnapshot = await _firestore.collection('Users').where('email', isEqualTo: userData['email']).get();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData['email'],
                recieverID: querySnapshot.docs.first.id,
                // isDoctor: userData['isDoctor'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
