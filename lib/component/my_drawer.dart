import 'package:flutter/material.dart';
import 'package:tremor_track/screens/hand_drawn_test.dart';
import 'package:tremor_track/screens/homePage.dart';
import 'package:tremor_track/screens/voice_test.dart';
import 'package:tremor_track/screens/wallet.dart';
import '../auth/auth_service.dart';
import '../constants/app_colors.dart';
import '../screens/health_record_view.dart';
import '../screens/homepage2.dart';
import '../screens/login.dart';
import '../screens/SettingPage.dart';
import '../screens/otherProfile.dart';
import '../screens/patient_doctor.dart';
import '../screens/profile_page.dart';
import 'my_list_tile.dart'; // Import the LoginPage

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  void logout(BuildContext context) {
    final _auth = AuthService();
    _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage after logout
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Drawer(
    //   backgroundColor: Colors.indigo,
    //   child: Column(
    //     children: [
    //       DrawerHeader(child: Center(child: Image(image: AssetImage('Img/photo_6021568892754837486_y.jpg')))),
    //       Padding(
    //         padding: EdgeInsets.only(left: 25),
    //         child: ListTile(
    //           title: Text(
    //             'H O M E',
    //             style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
    //           ),
    //           leading: Icon(Icons.home),
    //           onTap: () {
    //             Navigator.pop(context);
    //           },
    //         ),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(left: 25),
    //         child: ListTile(
    //           title: Text(
    //             'P R O F I L E',
    //             style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
    //           ),
    //           leading: Icon(Icons.settings),
    //           onTap: () {
    //             Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()),);
    //           },
    //         ),
    //       ),
    //       // Padding(
    //       //   padding: EdgeInsets.only(left: 25),
    //       //   child: ListTile(
    //       //     title: Text(
    //       //       'L O G O U T',
    //       //       style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
    //       //     ),
    //       //     leading: Icon(Icons.logout),
    //       //     onTap: () => logout(context), // Call logout function
    //       //   ),
    //       // )
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 25.0),
    //         child: MyListTile(
    //           icon: Icons.logout,
    //           text: "L O G O U T",
    //           onTap: () => logout(context),
    //         ),
    //       ),
    //
    //
    //     ],
    //   ),
    // );
    return Drawer(

      backgroundColor:  AppColors.mainColor,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(children: [
          DrawerHeader(child: Icon(Icons.person,color: Colors.white,size: 64,),
          ),
          MyListTile(icon: Icons.home, text: "H O M E",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage2()),);
            }),

          MyListTile(icon: Icons.person, text: "P R O F I L E", onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()),);
          } ),
          MyListTile(icon: Icons.front_hand_outlined, text: "H A N D _ T E S T",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HandDrawnTest()),);
              }),
          MyListTile(icon: Icons.settings_voice, text: "V O I C E _T E S T",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceTest()),);
              }),
            MyListTile(icon: Icons.search, text: "D O C T O R S",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
                }),
          MyListTile(icon: Icons.wallet_outlined  , text: "W A L L E T",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WalletPage()),);
              }),
          MyListTile(icon: Icons.healing, text: "H E A L T H R _ R E C O R D",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HealthRecord()),);
              }),


        ],)
          ,
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(icon: Icons.logout, text: "L O G O U T", onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
              //Navigator.of(context) .pushReplacementNamed("login");
            }, ),
          )

        ],),
    );
  }
}
