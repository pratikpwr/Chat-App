import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bar.dart';
import '../helper/constants.dart';
import '../services/database.dart';

class ChattingScreen extends StatefulWidget {
  final String chatRoomId;

  ChattingScreen(this.chatRoomId);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  DatabaseServices _databaseServices = new DatabaseServices();
  TextEditingController _sendController = new TextEditingController();

  Stream chatMessageStream;

  sendMessage() {
    if (_sendController.text.isNotEmpty) {
      Map<String, dynamic> _messageMap = {
        'message': _sendController.text,
        'sendBy': Constants.currentUsername,
        'time': DateTime.now().millisecondsSinceEpoch
      };

      _databaseServices.addChatMessage(widget.chatRoomId, _messageMap);
      _sendController.text = "";
    } else {
      //TODO: Implement enter message popup
      print('Enter message to send');
    }
  }

  @override
  void initState() {
    var result = _databaseServices.getChatMessages(widget.chatRoomId);

    chatMessageStream = result;

    super.initState();
  }

  Widget chatMessagesList() {
    return chatMessageStream == null
        ? Center(
            child: Text('Start Conversion'),
          )
        : StreamBuilder(
            stream: chatMessageStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                            snapshot.data.docs[index].get('message'),
                            snapshot.data.docs[index].get('sendBy') ==
                                Constants.currentUsername);
                      })
                  : Container();
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(context),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Flexible(child: chatMessagesList()),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
              sendMessageWidget(context)
            ],
          ),
        ));
  }

  Widget sendMessageWidget(BuildContext context) {
    return Container(
      //color: Theme.of(context).canvasColor,
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Theme.of(context).canvasColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sendController,
                  style: GoogleFonts.poppins(color: Colors.white),
                  cursorColor: Theme.of(context).accentColor,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    sendMessage();
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: GoogleFonts.poppins(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    sendMessage();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool _isSendByCurrentUser;

  MessageTile(this.message, this._isSendByCurrentUser);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      alignment:
          _isSendByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.fromLTRB(_isSendByCurrentUser ? 54 : 8, 10,
            _isSendByCurrentUser ? 8 : 54, 0),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isSendByCurrentUser
              ? const Color(0xffd931b3)
              : const Color(0xff3b1f50),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(_isSendByCurrentUser ? 0 : 20),
              bottomLeft: Radius.circular(_isSendByCurrentUser ? 20 : 0)),
        ),
        child: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
