import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tremor_track/component/drawer.dart';
import 'package:tremor_track/screens/homePage.dart';
import 'package:tremor_track/screens/patient_doctor.dart';
import 'package:tremor_track/screens/profile_page.dart';
import 'package:tremor_track/screens/hand_drawn_test.dart';
// import 'package:tremor_track/screens/home_page.dart'; // Ensure this import matches your HomePage file name
import 'package:tremor_track/screens/login.dart';
import 'package:tremor_track/screens/voice_test.dart';
import '../component/custombuttonauth.dart';
import '../component/my_drawer.dart';
import '../constants/app_colors.dart';
import '../services/chat/chat_services.dart';



class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final ChatService _chatService = ChatService();
  bool _isValueInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeValue();
  }

  Future<void> _initializeValue() async {
    await _chatService.initializeValue();
    setState(() {
      _isValueInitialized = true;
    });
  }

  void _goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValueInitialized) {
      return Scaffold(
        backgroundColor: Color(0xFFF4FFFE),
        appBar: AppBar(
          backgroundColor:  AppColors.mainColor,
          title: const Text(
            "Symptoms",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: const Text(
          "Symptoms",
          style: TextStyle(color: Colors.white),

        ),

        // actions: [
        //   IconButton(
        //
        //     onPressed: () async {
        //       await FirebaseAuth.instance.signOut();
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        //     },
        //     icon: Icon(Icons.exit_to_app,color: Colors.white),
        //   )
        // ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(

        child: Column(
        children: [ Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: AppColors.mainColor, // Border color
              width: 4, // Border width
            ),
          ),
          color: Colors.grey[50],
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tremor:",
                  style: TextStyle(color: AppColors.mainColor, fontSize: 20),
                ),
                Text(
                  'Rhythmic shaking, often starting in a limb, such as the hand or fingers. It might include a pill-rolling motion and may decrease during activity.',
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 15),
                Text(
                  "Slowed movement:",
                  style: TextStyle(color: AppColors.mainColor, fontSize: 20),
                ),
                Text(
                  "(Bradykinesia): As the disease progresses, movement becomes slower, making daily tasks challenging. Steps may shorten, and getting up from a chair might be difficult. Walking may involve dragging or shuffling feet.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 15),
                Text(
                  "Rigid muscles:",
                  style: TextStyle(color:AppColors.mainColor, fontSize: 20),
                ),
                Text(
                  "Stiffness can affect any part of the body, causing pain and limiting flexibility.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 15),
                Text(
                  'Impaired posture and balance:',
                  style: TextStyle(color: AppColors.mainColor, fontSize: 20),
                ),
                Text(
                  "Posture may become stooped, leading to balance issues and an increased risk of falls.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 15),
                Text(
                  "Speech and writing changes:",
                  style: TextStyle(color: AppColors.mainColor, fontSize: 20),
                ),
                Text(
                  "Speech may become softer, quicker, or hesitant. Writing may become harder, resulting in smaller handwriting.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 15),
                Text(
                  "Loss of automatic movements:",
                  style: TextStyle(color: AppColors.mainColor, fontSize: 20),
                ),
                Text(
                  "Reduced ability to perform unconscious movements like blinking, smiling, or swinging arms while walking.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 30),

              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HandDrawnTest()));
          },
          child:Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the Row's children horizontally
                      children: [
                        CustomButtonAuth(
                          w: 280,
                          title: 'Hand Test',
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HandDrawnTest()));
                          },
                        ),
                        SizedBox(width: 15),
                        CustomButtonAuth(
                          w: 280,
                          title: 'Voice Test',
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceTest()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.green, // Specify the color you want
                    borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners
                  ),
                  child: CustomButtonAuth(
                    w: 137,
                    title: _chatService.value ? 'Consultations Requests' : 'Search for Doctor',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                ),
              ],
            ),

          ),
          ),
    ]),
      ),
    );
  }
}


