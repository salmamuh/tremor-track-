
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/ChatPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('Users');
  List<Map<String, dynamic>> _searchResults = [];

  bool _isDoctor() {
    return FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.uid.startsWith('doctor_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          'Search for ${_isDoctor() ? 'Patients' : 'Doctors'}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name or email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults.clear();
                    });
                  },
                ),
              ),
              onChanged: (value) {
                _performSearch(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                  onTap: () {
                    _navigateToChatPage(user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      _usersCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get()
          .then((querySnapshot) {
        setState(() {
          _searchResults = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .where((user) =>
          user['email'] != FirebaseAuth.instance.currentUser!.email &&
              user['isDoctor'] != _isDoctor()) // Check if user is of opposite role (doctor/patient)
              .toList();
        });
      });
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  void _navigateToChatPage(Map<String, dynamic> user) {
    final String email = user['email'] ?? ''; // Use empty string as default value
    final String uid = user['uid'] ?? ''; // Use empty string as default value
    final bool isDoctor = user['isDoctor'] ?? false; // Use false as default value if isDoctor is not present

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          recieverEmail: email,
          recieverID: uid,

        ),
      ),
    );
  }
}

