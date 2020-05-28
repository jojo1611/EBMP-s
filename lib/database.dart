import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods{
  uploadUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap);
  }
  uploadRiderInfo(riderMap){
    Firestore.instance.collection("Rider").add(riderMap);
  }
  uploadDriverInfo(driverMap){
    Firestore.instance.collection("Driver").add(driverMap);
  }
  createChatRoom(String chatRoomId,chatRoomMap){
    Firestore.instance.collection("ChatRoom").document(chatRoomId).setData(chatRoomMap);
  }
}