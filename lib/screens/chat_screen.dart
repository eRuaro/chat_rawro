import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_rawro/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

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
  // void messagesStream() async {
  //   // Listens to all of the changes of the 'messages' collection
  //   await for (var messageStream
  //       in _firestore.collection('messages').snapshots()) {
  //     for (var message in messageStream.docs) {
  //       print(message.data());
  //     }
  //   }
  //   //Developer will be notified of any new changes in the collection
  // }

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
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
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
                      //clears the text field
                      messageTextController.clear();
                      //messages is the document name in firestore
                      _firestore.collection('messages').add({
                        //text and sender are the types in firestore
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });

                      // messagesStream();
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
  @override
  Widget build(BuildContext context) {
    return //Query Snapshot comes from cloud firestore
        StreamBuilder<QuerySnapshot>(
      //Where the streams will be coming from
      stream: _firestore.collection('messages').snapshots(),
      //Rebuilds the widget with the streams
      //defined in docs -> context, snapshot -> different from firebase snapshot
      builder: (context, snapshot) {
        //builds a text widget
        List<MessageBubble> messageWidgets = [];

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }

        //new texts appear at the bottom
        final messages = snapshot.data.docs.reversed;

        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];

          final currentUser = loggedInUser.email;

          if (currentUser == messageSender) {
            //messages from current user
          }

          final messages = MessageBubble(
            messageSender,
            messageText,
            currentUser == messageSender,
          );

          messageWidgets.add(messages);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(this.sender, this.text, this.isMe);

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            //adds border
            borderRadius: BorderRadius.only(
              topLeft: isMe? Radius.circular(30) : Radius.circular(0),
              topRight: isMe ? Radius.circular(0) : Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            // elevation adds shadow
            elevation: 5.0,
            color: isMe ? Colors.black54 : Colors.blueGrey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
