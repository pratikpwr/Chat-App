import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/constants.dart';
import '../helper/local_db.dart';
import '../screens/chatting_screen.dart';
import '../screens/search_screen.dart';
import '../services/database.dart';
import '../helper/authenticate.dart';
import '../services/auth_services.dart';

class AllChatsScreen extends StatefulWidget {
  @override
  _AllChatsScreenState createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  AuthServices _authServices = new AuthServices();
  DatabaseServices _databaseServices = new DatabaseServices();
  Stream allChatsStream;

  getCurrentUser() async {
    Constants.currentUsername = await LocaleDB.getUsernameDB();
    var result = _databaseServices.getChatRooms(Constants.currentUsername);
    setState(() {
      allChatsStream = result;
    });
    print(Constants.currentUsername);
  }

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: allChatsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    print(snapshot.data.toString());
                    return ChatRoomTile(snapshot.data.docs[index].get('id'));
                  })
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat App',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _authServices.signOut();
                LocaleDB.saveUserAuthStatusDB(false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => Authenticate()));
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => SearchScreen()));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String chatRoomId;

  ChatRoomTile(this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(50)),
            child: Text(
              chatRoomId
                  .replaceAll("_", "")
                  .replaceAll(Constants.currentUsername, "")
                  .substring(0, 1)
                  .toUpperCase(),
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Text(
            chatRoomId
                .replaceAll("_", "")
                .replaceAll(Constants.currentUsername, ""),
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
          ),
          Spacer(),
          IconButton(
              icon: Transform.rotate(
                angle: 5.5,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChattingScreen(chatRoomId)));
              })
        ],
      ),
    );
  }
}
