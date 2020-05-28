import 'package:flutter/material.dart';
import 'database.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
DatabaseMethods databaseMethods = new DatabaseMethods();
  createChatRoomAndStartChat(String username){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat",style: TextStyle(
          fontSize:30
        ),),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}
