import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tremor_track/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/auth_service.dart';


class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool value;
  bool? _isDoctor;
  Future<void> initializeValue() async {
    final String currentUserID = _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await _firestore.collection('Users').doc(currentUserID).get();
    value = snapshot.get('isDoctor');
  }
  Future<bool?> get isDoctor async {
    if (_isDoctor == null) {
      await initializeValue();
    }
    return _isDoctor;
  }
  Future<Stream<List<Map<String, dynamic>>>> getUsersStream() async {
    await initializeValue();
    return _firestore
        .collection('Users')
        .where('isDoctor', isEqualTo: !value)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data() as Map<String, dynamic>;
        return user;
      }).toList();
    });
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore.collection('chat_room')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(String recieverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        timestamp: timestamp,
        senderEmail: currentUserEmail,
        senderID: currentUserID,
        recieverID: recieverID,
        message: message);

    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore.collection('chat_room')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());

    print(value);
    if (value) {
      await AuthService().updateBalance(-5, recieverID);
      await AuthService().updateBalance(5, currentUserID);
    } else {
      await AuthService().updateBalance(5, currentUserID);
    }
  }
}
