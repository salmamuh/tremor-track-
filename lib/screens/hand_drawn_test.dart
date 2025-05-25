import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tremor_track/models/paymob_manager.dart';
import 'package:tremor_track/screens/result_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/or_divider.dart';
import '../widgets/upload_image.dart';
import 'package:tremor_track/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


import 'package:path/path.dart' as p;




User? user = FirebaseAuth.instance.currentUser;

String? userId = user?.uid;
bool pay=false;
class HandDrawnTest extends StatefulWidget {
  const HandDrawnTest({super.key});

  @override
  State<HandDrawnTest> createState() => _HandDrawnTestState();
}

class _HandDrawnTestState extends State<HandDrawnTest> {
  String? _url;
  final picker = ImagePicker();
  File? _imageFile;


  late String imageUrl;

  void initState() {
    super.initState();
    // Fetch the current test count from Firestore
    fetchTestCount();
  }




  Future<void> updateTestResults(String userId, String newResults) async {
    // uploadImageToFirebaseStorage(userId, imageFile);
    // Get a reference to the user's document
    DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(userId);
    imageUrl = '';
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      imageUrl = userData.get('image');
    } catch (e) {
      print('Error fetching image URL from Firestore: $e');
      return;
    }
    // Update the 'tests' field with the new results
    userRef.update({
      'tests': FieldValue.arrayUnion([
        {
          'date_time': DateTime.now().toString(),
          'image_url': _url,
          'result': newResults, // Or set to whatever initial result you want
        }
      ]),
    }).then((_) {
      print('Test results updated successfully!');
    }).catchError((error) {
      print('Failed to update test results: $error');
    });
  }


  Future<void> pickImageFromCamera() async {

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
          centerTitle: true, // like this!
        ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Center(
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "Hand Drawn Parkinson Test",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                    ),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        pickImageFromGallery();

                      },
                      child:Container(

                          height:220,
                          width :350,
                          decoration: BoxDecoration(
                            color: Colors.white,
                              border: Border.all(
                                color: AppColors.mainColor, // Border color
                                width: 2, // Border width
                              ),
                              borderRadius: BorderRadius.circular(25)
                          ),
                      child: _imageFile != null ? Image.file(_imageFile!) : UploadImagec(),),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            OrDivider(),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {

                pickImageFromCamera();
                // uploadImageToFireStorage(context, _imageFile!);
              },
              child: Container(

                width: MediaQuery.of(context).size.width - 240,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "Take Photo",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: () async {

               if (currentTestCount<3)
                 {uploadImageToFireStorage(context, _imageFile!);
                   await updateTestCount(userId!);
                 uploadImage();}

               else{
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
        Navigator.of(context).pop(); // Close the dialog
        await _pay(); // Call the _pay function
        if (pay) {
          await updateTestCount(userId!);
          uploadImage();
          // Reset the pay flag for future payments
          setState(() {
            pay = false;
          });
        }
        uploadImageToFireStorage(context, _imageFile!);
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
    }



              },
              child: Container(
                width: max(MediaQuery.of(context).size.width - 240, 0), // Ensure width is not negative
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  border: Border.all(
                    color: Color(0xFF458C55), // Border color
                    width: 4, // Border width
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  "Get Result",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              )

              ,
            ),
            // Text(currentTestCount.toString()),
          ],
        ),
      ),
    );
  }
  late int currentTestCount;

  Future<void> _pay() async {
    try {
      String paymentKey = await PaymobManager().getPaymentKey(100, "EGP");
      await launchUrl(
        Uri.parse("https://accept.paymob.com/api/acceptance/iframes/844284?payment_token=$paymentKey"),
      );
      // You would ideally listen for a payment success event here
      // For demonstration purposes, we simulate a successful payment after 3 seconds
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        pay = true; // Simulated payment success
      });
    } catch (e) {
      print("Error during payment: $e");
      // Handle payment error
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

        // Update the UI with the new test count
        setState(() {
          currentTestCount = currentTestCount + 1;
        });
      }
    });
  }

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

  Future<void> uploadImage() async {
    if (_imageFile == null) return;
    String base64 = base64Encode(_imageFile!.readAsBytesSync());
    Map<String, String> requestHeader = {
      'content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      var response = await http.put(Uri.parse("http://192.168.228.110:5000/api"), body: base64, headers: requestHeader);

      // Convert the response body into a Map
      String data = response.body;

      // Increment test count after successful upload


      // Now you can use the data as a Map
      print(data);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultView(result: data, image: _imageFile,),
        ),
      );

      updateTestResults(userId!,  data!);
    } catch (e) {
      print("Error: $e");
    }
  }
  // import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;






  void uploadImageToFireStorage(BuildContext context, File _imageFile) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(_imageFile.path);
      UploadTask uploadTask = ref.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
       _url = await taskSnapshot.ref.getDownloadURL();
      print('Upload successful. Download URL: $_url');
    } catch (e) {
      print('Error uploading to Firebase Storage: $e');
    }


  }

}


  // void addImageUrlToUserTests(String userId, String imageUrl) {
  //   // Get the reference to the user's document
  //   var userRef = FirebaseFirestore.instance.collection('Users').doc(userId);
  //
  //   // Update the tests Map with the new image URL
  //   userRef.update({
  //     'tests': FieldValue.arrayUnion([
  //       {
  //         'date_time': DateTime.now().toString(),
  //         'image_url': imageUrl,
  //         'result': 'Pending', // Or set to whatever initial result you want
  //       }
  //     ])
  //   }).then((_) {
  //     print('Image URL added to user tests in Firestore');
  //   }).catchError((error) {
  //     print('Failed to add image URL to user tests: $error');
  //   });
  // }



// String? tbody="";

