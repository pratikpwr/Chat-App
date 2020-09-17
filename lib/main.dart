import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './helper/authenticate.dart';
import './helper/local_db.dart';
import './screens/all_chats_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: const Color(0xffD933C3),
          canvasColor: const Color(0xff1c0436),
          // scaffoldBackgroundColor: const Color(0xff070219),
          // backgroundColor: const Color(0xff231454),
          cardColor: const Color(0xff3b1f50),
          accentColor: const Color(0xffd933c3)),
      home: Route(),
    );
  }
}

class Route extends StatefulWidget {
  @override
  _RouteState createState() => _RouteState();
}

class _RouteState extends State<Route> {
  bool _isSignIn = false;

  @override
  void initState() {
    getAuthInfo();
    super.initState();
  }

  getAuthInfo() async {
    await LocaleDB.getUserAuthStatusDB().then((value) {
      setState(() {
        _isSignIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignIn != null
        ? _isSignIn ? AllChatsScreen() : Authenticate()
        : Authenticate();
  }
}
