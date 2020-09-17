import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  uploadUserInfo(userInfoMap) {
    FirebaseFirestore.instance
        .collection('users')
        .add(userInfoMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserByUsername(username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      print(error.toString());
    });
  }

  getUserByUserEmail(userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get()
        .catchError((error) {
      print(error.toString());
    });
  }

  createChatRoom(chatRoomId, chatRoomMap) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((onError) {
      print(onError.toString());
    });
  }

  addChatMessage(chatRoomId, messageMap) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageMap)
        .catchError((onError) {
      print(onError.toString());
    });
  }

  getChatMessages(chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  getChatRooms(username) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .where('users', arrayContains: username)
        .snapshots();
  }
}
