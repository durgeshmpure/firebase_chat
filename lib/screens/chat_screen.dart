import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:untitled/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;
late User loggedinUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final auth = FirebaseAuth.instance;


  String? messageText;
  bool showLoadingScreen = false;
  var textcontroller = TextEditingController();

  void getCurrentUser() async {
    try {
      final user = await auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
                auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Montserrat'),
                      controller: textcontroller,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textcontroller.clear();
                      firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedinUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = (snapshot.data! as QuerySnapshot).docs.reversed;
          List<Widget> messageWidgets = [];
          for (var message in messages) {
            final messageText = message['text'];
            final messageSender = message['sender'];
            final currentUser = loggedinUser.email;
            final messageBubble = MessageBubble(messageSender, messageText,currentUser==messageSender);
            messageWidgets.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
            ),
          );
        } else {
          return LoaderOverlay(child: MaterialApp());
        }
      },
      stream: firestore.collection('messages').orderBy('time',descending: false).snapshots(),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  MessageBubble(this.sender, this.text,this.isMe);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        Text(
          sender,
          style: TextStyle(
              fontSize: 11, fontFamily: "Montserrat", color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Material(
            borderRadius:isMe? BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)
            ):BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ),
            elevation: 10,
            color:isMe ? Colors.lightBlueAccent:Colors.white,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(text,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        color: isMe?Colors.white:Colors.black,
                        fontSize: 20))),
          ),
        ),
      ],
    );
  }
}
