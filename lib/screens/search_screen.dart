import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bar.dart';
import '../helper/constants.dart';
import '../screens/chatting_screen.dart';
import '../services/database.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseServices _databaseServices = new DatabaseServices();
  TextEditingController _searchController = new TextEditingController();
  QuerySnapshot userSnapshot;

  initiateSearch() async {
    var data =
        await _databaseServices.getUserByUsername(_searchController.text);
    print(data);
    setState(() {
      userSnapshot = data;
    });
  }

  startConversation(String userName) {
    if (userName != Constants.currentUsername) {
      List<String> users = [userName, Constants.currentUsername];
      String chatRoomId = getChatRoomId(userName, Constants.currentUsername);
      Map<String, dynamic> chatRoomMap = {'users': users, 'id': chatRoomId};

      _databaseServices.createChatRoom(chatRoomId, chatRoomMap);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ChattingScreen(chatRoomId);
      }));
    } else {
      print('Cannot send Message to yourself');
      //TODO: implement not searching yourself
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: Container(
        child: Column(
          children: [
            searchBox(context),
            userSnapshot == null
                ? Center(
                    child: Text(
                    'Search User',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ))
                : usersListBuilder()
          ],
        ),
      ),
    );
  }

  Widget usersListBuilder() {
    return userSnapshot.docs.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: userSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                userSnapshot.docs[index].get('username'),
                userSnapshot.docs[index].get('email'),
              );
            })
        : CircularProgressIndicator();
  }

  Container searchBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.poppins(color: Colors.white),
              cursorColor: Theme.of(context).accentColor,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                initiateSearch();
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.poppins(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                initiateSearch();
              })
        ],
      ),
    );
  }

  Widget userTile(_username, _userEmail) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _username,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 17),
              ),
              Text(
                _userEmail,
                style: GoogleFonts.poppins(color: Colors.white),
              )
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
              startConversation(_username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(25)),
              child: Text('Message',
                  style:
                      GoogleFonts.poppins(color: Colors.white, fontSize: 17)),
            ),
          )
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  //TODO: Generate more unique id
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
