import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:tremor_track/screens/result_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import '../models/paymob_manager.dart';





class VoiceTest extends StatefulWidget {
  const VoiceTest({Key? key}) : super(key: key);

  @override
  State<VoiceTest> createState() => _VoiceTestState();
}

class _VoiceTestState extends State<VoiceTest> {
  late int currentTestCount;
  String? audioUrl;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String? audioPath;
  String resultMessage = '';
  double prediction = 0.0;

  bool pay = false;

  User? user;
  String? userId;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    fetchTestCount();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print("Error Start Recording : $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path ?? '';
      });
    } catch (e) {
      print('Error Stopping Record : $e');
    }
  }

  Future<void> playRecording() async {
    try {
      if (audioPath != null && audioPath!.isNotEmpty) {
        await audioPlayer.play(UrlSource(audioPath!));
      }
    } catch (e) {
      print('Error Playing Recording $e');
    }
  }

  void addTestResult(String userId, List<dynamic> testResults) {
    CollectionReference userTests = FirebaseFirestore.instance.collection('Users');

    userTests.doc(userId).set({
      'tests': testResults,
    }, SetOptions(merge: true)).then((value) {
      print("Test results added successfully!");
    }).catchError((error) {
      print("Failed to add test results: $error");
    });
  }

  Future<void> uploadAndPredict(String method) async {
    print('Audio path: $audioPath');
    final url = Uri.parse('http://192.168.181.110:5000/process_audio');
    try {
      late http.Response response;
      if (method == 'PUT') {
        final bytes = await File(audioPath!).readAsBytes();
        final base64Data = base64Encode(bytes);
        response = await http.put(
          url,
          body: json.encode({'audioData': base64Data}),
          headers: {
            'Content-Type': 'application/json',},);
      } else if (method == 'GET') {
        response = await http.get(url);
      } else {
        throw Exception('Invalid HTTP method');}
      if (response.statusCode == 200) {
        final data = response.body;
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ResultView(
              result: data,
              audioPath: audioPath,
            ),
          ),
        );
        updateTestResults(userId!, data);
      } else {
        print('Failed to upload file: ${response.statusCode}');}
    } catch (e) {print('Error uploading file: $e');}}

  Future<void> fetchTestCount() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection('Users').doc(userId!);

    DocumentSnapshot snapshot = await userRef.get();
    if (snapshot.exists) {
      setState(() {
        currentTestCount = snapshot.get('testCount') ?? 0;
      });
    }
  }
  Future<void> updateTestResults(String userId, String newResults) async {
    DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(userId);
    String imageUrl = '';
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      imageUrl = userData.get('image');
    } catch (e) {
      print('Error fetching image URL from Firestore: $e');
      return;
    }

    userRef.update({
      'tests': FieldValue.arrayUnion([
        {
          'date_time': DateTime.now().toString(),
          'audio_url': audioUrl,
          'result': newResults,
        }
      ]),
    }).then((_) {
      print('Test results updated successfully!');
    }).catchError((error) {
      print('Failed to update test results: $error');
    });
  }

  Future<void> uploadAudioToFireStorage(BuildContext context, String audioPath) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('audios').child('audio_filename.m4a');
      UploadTask uploadTask = ref.putFile(File(audioPath));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      audioUrl = await taskSnapshot.ref.getDownloadURL();
      print('Upload successful. Download URL: $audioUrl');
    } catch (e) {
      print('Error uploading audio to Firebase Storage: $e');
    }
  }

  Future<void> _pay() async {
    try {
      String paymentKey = await PaymobManager().getPaymentKey(100, "EGP");
      await launchUrl(
        Uri.parse("https://accept.paymob.com/api/acceptance/iframes/844284?payment_token=$paymentKey"),
      );
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        pay = true;
      });
    } catch (e) {
      print("Error during payment: $e");
    }
  }

  Future<void> updateTestCount(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection('Users').doc(userId);

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (snapshot.exists) {
        currentTestCount = snapshot.get('testCount') ?? 0;

        transaction.update(userRef, {'testCount': currentTestCount + 1});

        setState(() {
          currentTestCount = currentTestCount + 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Container(
          width: 40,
          child: Image.asset('assets/logo.png'),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Container(
                    height:50,
                    width:50,
                    child: Icon(Icons.info, color: AppColors.mainColor.withOpacity(0.7),size: 35)), // Set the icon color to blue
                onPressed: () {
                  // Display instructions
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Voice Recording Instructions'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('1. Find a Quiet Place: Choose a quiet room with minimal background noise.'),
                              Text('2. Position the Phone: Hold your phone 6-12 inches (15-30 cm) from your mouth.'),
                              Text('3. Record These Steps:'),
                              Text('  - Sustained Vowel: Say "ah" for 3-5 seconds.'),
                              Text('  - Conversational Speech: Talk about your day for 30-60 seconds.'),
                              Text('4. Check and Submit: Listen to your recording for clarity. Save and submit if the audio is clear and free of noise.'),
                              Text('Tips: Speak clearly and at a steady pace.'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Got it'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
SizedBox(height:150),
            Text(
              "Voice Record Parkinson Test",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
            ),
            SizedBox(height: 50),
            if (isRecording)
              Text(
                'Recording in Progress',
                style: TextStyle(fontSize: 20),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Set background color to transparent
                padding: EdgeInsets.zero, // Remove default padding
                shadowColor: Colors.transparent, // Remove the shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Match the container's border radius
                ),
              ),

              onPressed: isRecording ? stopRecording : startRecording,
              child: isRecording
                  ? Text("Stop Recording")
                  : Container(
                height: 105,
                width: 95,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  border: Border.all(
                    color: Color(0xFF458C55),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset('assets/icons8-microphone-48.png'),
              ),
            ),
            SizedBox(height: 20),
            if (!isRecording && audioPath != null && audioPath!.isNotEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: AppColors.mainColor.withOpacity(0.4 ), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Rounded corners
                  ),
                  // side: BorderSide(
                  //   color: Color(0xFF458C55), // Border color
                  //   width: 4, // Border width
                  // ),
                ),
                onPressed: playRecording,
                child: Text("Play Recording"),
              ),

            SizedBox(height: 20),
            if (!isRecording && audioPath != null && audioPath!.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  if (currentTestCount < 3) {
                    await updateTestCount(userId!);
                    uploadAndPredict('PUT');
                    uploadAudioToFireStorage(context, audioPath!);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Payment Information'),
                          content: Text('You have reached the maximum test limit. Click below to pay 100 EGP for test.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Proceed to Payment'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await _pay();
                                if (pay) {
                                  await updateTestCount(userId!);
                                  uploadAndPredict('PUT');
                                  setState(() {
                                    pay = false;
                                  });
                                }
                              },
                            ),
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    uploadAudioToFireStorage(context, audioPath!);
                  }
                },
                child: Container(
                  width: max(MediaQuery.of(context).size.width - 240, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    border: Border.all(
                      color: Color(0xFF458C55),
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    "Get Result",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}
