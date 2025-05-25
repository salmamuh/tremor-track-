import 'package:flutter/material.dart';
import 'package:tremor_track/screens/signUp.dart';

import 'login.dart';





class firstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to patient login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login as Patient'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),

            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to doctor login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login as Doctor'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Login'),
      ),
      body: Center(
        child: Text('Patient Login Page'),
      ),
    );
  }
}

class DoctorLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Login'),
      ),
      body: Center(
        child: Text('Doctor Login Page'),
      ),
    );
  }
}

