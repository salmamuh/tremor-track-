import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  User?getCurrentUser(){
    return _auth.currentUser;
  }

  //sign in

  Future<UserCredential> signInWithEmailPasswrd(String email,
      String password,String name) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //save user info into separate doc
      _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'email':email,
        'name':name,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

//sign out
  Future <void> signOut() async {
    return await _auth.signOut();
  }

//sign up
  Future<UserCredential> signUpWithEmailPasswrd(String email,
      String password,String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //save user info into separate doc
      _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'email':email,
        'name':name,
        'confirm': false,

      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  Future<void> updateBalance(int amount,String? userId) async {
    // String? userId = getCurrentUser()?.uid;
    if (userId != null) {
      await _firestore.collection('Users').doc(userId).update({'balance': FieldValue.increment(amount)});
    }
  }
  Future<int?> getUserBalance() async {
    String? userId = getCurrentUser()?.uid;
    try {
      // String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(userId).get();
        return userDoc.get('balance');
      }
    } catch (e) {
      print("Error fetching user balance: $e");
    }
    return null;
  }
  final CollectionReference<Map<String, dynamic>> usersCollection =
  FirebaseFirestore.instance.collection('Users');

  Future<List<dynamic>> getUserTests(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await usersCollection.doc(userId).get();

    return userSnapshot.get('tests') ?? [];
  }

}