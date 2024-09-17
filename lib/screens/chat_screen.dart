// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _firestore = FirebaseFirestore.instance;
late User loggedInUser;


class ChatScreen extends StatefulWidget {

  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
  // FirebaseUser loggedInUser;
  // late User loggedInUser;

  // as _firestore is private we can't assess in different class
  // final _firestore = FirebaseFirestore.instance;
  late String messageText;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try{
      final user = _auth.currentUser!;
      if(user != null){
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for(var message in messages.docs){
  //     print(message.data());
  //   }
  // }

  // void messagesStream() async {
  //   await for(var snapshot in _firestore.collection('messages').snapshots()){
  //     for(var message in snapshot.docs){
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () async {
              // messagesStream();
              await _auth.signOut();
              Navigator.pop(context); // Or navigate to the login screen
            },
          ),
        ],
        title: Center(child: Text('⚡️Flash_Chat')),
        backgroundColor: Colors.lightBlueAccent,
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      messageTextController.clear();
                      try {
                        await _firestore.collection('messages').add({
                           'text': messageText,
                           'sender': loggedInUser.email,
                           'timestamp': FieldValue.serverTimestamp(),  // Adds a server timestamp
                        });
                      } catch (error) {
                          // Handle the error and provide user feedback
                          print("Failed to add message: $error");
                          // Optionally, show a message to the user or log the error
                          // e.g., showDialog(context: context, builder: (context) => AlertDialog(...));
                      }



                      // _firestore.collection('messages').add({
                      //   'text': messageText,
                      //   'sender': loggedInUser.email,
                      //   // adding the timestamp in DB
                      //   'timestamp': FieldValue.serverTimestamp(),
                      // }).catchError((error) {
                      //   print("Failed to add message: $error");
                      // });
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


class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // GETTING DATA FROM FIREBASE
      stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
      // Order messages by timestamp
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show CircularProgressIndicator while waiting for data
          return Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,  // Thicker stroke
                ),
              ),
            ),
          );
        }
        if(snapshot.hasData){
          final messages = snapshot.data!.docs;
          // list of MessageBubble widgets
          List<MessageBubble> messageBubbles = [];
          for(var message in messages){
            final messageData = message.data() as Map<String, dynamic>;  // Access the data as a Map.
            final messageText = messageData['text'];
            final messageSender = messageData['sender'];
            final messageTime = messageData['timestamp'];


            // HANDLE THE CASE WHERE TIMESTAMP MIGHT BE NULL
            if (messageTime == null) {
              // return Text('Timestamp is missing for this message.');
              return Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 6.0,  // Thicker stroke
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),  // Custom color
                    ),
                  ),
                ),
              );
            }

            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              timestamp: messageTime,
              isMe: currentUser==messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          // MAIN RETURN OF WIDGET IN UI
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              children: messageBubbles,
            ),
          );
        }else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }else {
          // Show a loading indicator while data is being fetched.
          return Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,  // Thicker stroke
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),  // Custom color
                ),
              ),
            ),
          );
        }
      },
    );
  }
}





class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.isMe
  });

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {

    final dateTime = timestamp.toDate(); // Convert Firestore Timestamp to DateTime
    final formattedTime = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}'; // Basic formatting

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 10.0,
            shadowColor: Colors.black,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            // borderRadius: BorderRadius.circular(20.0),
            borderRadius: isMe ? BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))
                : BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.lightBlueAccent,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

