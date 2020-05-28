import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_webservice/places.dart';

class FirebaseMessagingDemo extends StatefulWidget {
  @override
  FirebaseMessagingDemo():super();
  final String title = 'Firebase Messaging';
   State<StatefulWidget>createState() => FirebaseMessagingDemoState();
}

class FirebaseMessagingDemoState extends State<FirebaseMessagingDemo> {
  final FirebaseMessaging _fireBaseMessaging = FirebaseMessaging();
  List<Message> _messages;

  _getToken(){
    _fireBaseMessaging.getToken().then((deviceToken){
      print("Device Token: $deviceToken");
    });
  }
  _configureFireBaseListeners(){
    _fireBaseMessaging.configure(
      onMessage: (Map<String,dynamic> message)async{
      print('onMessage:$message');
      _setMessage(message);
      },
      onLaunch: (Map<String,dynamic> message)async {
        print('onLaunch:$message');
      },
      onResume: (Map<String,dynamic> message)async{
      print('onResume:$message');
      },
    );
  }

  _setMessage(Map<String,dynamic> message){
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMesssage = data['message'];
    setState(() {
      Message m = Message(title, body, message);
      _messages.add(m);
    });
  }
  @override
  void initState() {

    super.initState();
    _messages=List<Message>();
    _getToken();
    _configureFireBaseListeners();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: ListView.builder(itemCount: null==_messages ? 0 : _messages.length,
        itemBuilder: (context,index){
        return Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              _messages[index].message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
class Message{
  String title;
  String body;
  String message;
  Message(title,body,message){
    this.title = title;
    this.body = body;
    this.message = message;
  }
}
