
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tremor_track/auth/auth_service.dart';
import 'package:tremor_track/component/chatBubbl.dart';
import 'package:tremor_track/services/chat/chat_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import 'health_record_view.dart';
import 'otherProfile.dart';
import 'wallet.dart';
import '../models/paymob_manager.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;

  ChatPage({Key? key, required this.recieverEmail, required this.recieverID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool pay = false;
  bool isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  late bool confirm;
  late bool isDoctor;

  @override
  void initState() {
    super.initState();
    _fetchReceiverData();
  }

  Future<void> _fetchReceiverData() async {
    DocumentSnapshot receiverSnapshot = await FirebaseFirestore.instance.collection('Users').doc(widget.recieverID).get();
    setState(() {
      confirm = receiverSnapshot['confirm'] ?? false;
      isDoctor = receiverSnapshot['isDoctor'] ?? false;
      isLoading = false;
    });
  }

  // send messages
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.recieverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage2(rUser: widget.recieverID)));
          },
          child: Text(
            widget.recieverEmail,
            textAlign: TextAlign.center
            ,style: TextStyle( color: Colors.white,),
          ),
        ),
        backgroundColor:  AppColors.mainColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back button here
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(child: _buildMessageList()),

          _buildUserInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading..');
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    return Container(
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(messages: data['message'], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  Widget _buildUserInput(BuildContext context) {
    String senderID = _authService.getCurrentUser()!.uid;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _messageController,
                onSubmitted: (message) {
                  sendMessage();
                },
              ),
            ),
          ),
          Visibility(
            visible: confirm != null && !isDoctor && confirm,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HealthRecord(rId: widget.recieverID),
                      ),
                    );
                  },
                  child: Text(
                    'Health record',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isDoctor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withOpacity(0.2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: TextButton(
                  onPressed: () async {
                    DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(senderID);
                    await userRef.update({'confirm': true});
                  },
                  child: Text(
                    'Confirm Results',
                    style: TextStyle( color: AppColors.mainColor,),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: () async {
                DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Users').doc(senderID).get();
                bool value = snapshot.get('isDoctor');
                if (value) {
                  sendMessage();
                  _messageController.clear();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Payment Information'),
                        content: Text('Pay 5 EGP to send message.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Proceed to Payment'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _pay();
                              if (pay) {
                                setState(() {
                                  pay = false;
                                });
                                sendMessage();
                              }
                              _messageController.clear();
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
              icon: Icon(Icons.send),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pay() async {
    try {
      String paymentKey = await PaymobManager().getPaymentKey(5, "EGP");
      await launch("https://accept.paymob.com/api/acceptance/iframes/844284?payment_token=$paymentKey");
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        pay = true;
      });
    } catch (e) {
      print("Error during payment: $e");
    }
  }
}

