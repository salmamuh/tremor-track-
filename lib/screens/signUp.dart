import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/auth_service.dart';
import '../constants/app_colors.dart';
import 'homePage.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
   // Track whether the user is a doctor or not
  String? _gender; // Track the selected gender
  bool isDoctor = false;
  void _signUp(BuildContext context) async {
    final _auth = AuthService();

    try {
      // Check if passwords match
      if (_pwController.text == _confirmController.text) {
        // Create user account with email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _pwController.text,
        );

        // Update user display name
        await userCredential.user?.updateDisplayName(_nameController.text.trim());

        // Add additional user information to Firestore
        await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'age': _ageController.text.trim(),
          'phone': _mobileController.text.trim(),
          'isDoctor': isDoctor, // Save the doctor status
          'gender': _gender,
          'address':_addressController.text.trim(),
          'description':_descriptionController.text.trim(),
          'confirm':false,// Save the selected gender
        });

        // Navigate to home page after successful sign-up
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        throw 'Password does not match';
      }
    } catch (e) {
      print("Error: $e");
      // Handle sign up errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sign Up Error"),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      appBar: AppBar(
        backgroundColor:AppColors.mainColor,
        title: Text("Sign Up",style: TextStyle(
          color: Colors.white,
         ),),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the drawer icon here
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/logo.png',height:90,width: 90,),
              Center(
                child: Text(
                  "Welcome !",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _pwController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _confirmController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile Phone'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(height: 12.0),
              Row(
                children: [
                  Text('Gender: ',style:Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).inputDecorationTheme.labelStyle?.color ??
                        Theme.of(context).hintColor,
                  )),
                  Checkbox(
                    value: _gender == 'Male',
                    onChanged: (value) {
                      setState(() {
                        _gender = 'Male';
                      });
                    },
                  ),
                  Text('Male'),
                  Checkbox(
                    value: _gender == 'Female',
                    onChanged: (value) {
                      setState(() {
                        _gender = 'Female';
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
        
              SizedBox(height: 16.0),
        
              Row(
                children: [
                  Text('Are you a doctor?',style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).inputDecorationTheme.labelStyle?.color ??
                        Theme.of(context).hintColor,
                  ),),
                  Checkbox(
                    value: isDoctor,
                    onChanged: (value) {
                      setState(() { // Use setState here
                        isDoctor = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Tell us about yourself',

                ),
                maxLines: null, // Allow multiple lines for description
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () => _signUp(context),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 15, // Match the font size of the Container's child Text
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.mainColor),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Match the padding of the Container
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // Match the border radius of the Container
                      side: BorderSide(
                        color: Color(0xFF458C55), // Border color
                        width: 4, // Border width
                      ),
                    ),
                  ),
                ),
              ),
SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),

                    Text(
                      'Log in ',
                      style: TextStyle(
                        color: AppColors.mainColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}



