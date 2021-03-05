import 'package:flutter/material.dart';
import 'package:chat_rawro/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;

  User loggedInUser;

  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //gives us all documents in a collection
  // void getMessages() async {
  //   //messages is collection name
  //  final messages = await _firestore.collection('messages').get();
  //
  //  //grabs document
  //   for (var message in messages.docs) {
  //     //prints the key value pair in the documents (indiv messages) of the message collection
  //     print(message.data());
  //   }
  // }

  //Notifies firebase of a new message
  void messagesStream() async {
    // Listens to all of the changes of the 'messages' collection
    await for (var messageStream
        in _firestore.collection('messages').snapshots()) {
      for (var message in messageStream.docs) {
        print(message.data());
      }
    }
    //Developer will be notified of any new changes in the collection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡ ️Rawro Chat'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Query Snapshot comes from cloud firestore
            StreamBuilder<QuerySnapshot>(
              //Where the streams will be coming from
              stream: _firestore.collection('messages').snapshots(),
              //Rebuilds the widget with the streams
              //defined in docs -> context, snapshot -> different from firebase snapshot
              builder: (context, snapshot) {
                //builds a text widget
                List<Text> messageWidgets = [];

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue,
                    ),
                  );
    }
                  final messages = snapshot.data.docs;

                  for (var message in messages) {
                    final messageText = message.data()['text'];
                    final messageSender = message.data()['sender'];

                    final messageWidget =
                        Text('$messageText from $messageSender\n');

                    messageWidgets.add(messageWidget);
                  }
                  return Column(
                    children: messageWidgets,
                  );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //messages is the document name in firestore
                      _firestore.collection('messages').add({
                        //text and sender are the types in firestore
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });

                      messagesStream();
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
